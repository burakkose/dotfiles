#!/bin/bash
# -------------------------------------------------------------------------
# 2.5G ETHERNET OPTIMIZER (Arch Linux / Desktop Profile)
# -------------------------------------------------------------------------
# This script is a personal experimentation project aimed at finding the
# "sweet spot" for 2.5GbE performance on my specific local network.
#
# WARNING: This is a playground, not a production script. These
# settings are tuned for low-latency desktop use for my own need
# and may not be ideal for your specific hardware or workload.
# Use at your own risk.
# -------------------------------------------------------------------------

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

SCRIPT_VERSION="1.0"
BACKUP_DIR="/var/lib/net-tuning-backup"
SYSCTL_FILE="/etc/sysctl.d/99-network-performance.conf"
SYSTEMD_SERVICE="/etc/systemd/system/nic-tuning.service"

# Root check
if [[ $EUID -ne 0 ]]; then
    echo -e "${RED}This script must be run as root (use sudo)${NC}"
    exit 1
fi

usage() {
    echo -e "${BLUE}2.5G Ethernet Optimizer v${SCRIPT_VERSION} (Desktop)${NC}"
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -i, --interface IFACE   Specify interface (auto-detects if omitted)"
    echo "  -r, --rollback          Restore previous settings"
    echo "  -d, --dry-run           Show what would be done without applying"
    echo "  -h, --help              Show this help"
    echo ""
    echo "Examples:"
    echo "  $0                      # Auto-detect and optimize"
    echo "  $0 -i enp14s0           # Specify interface"
    echo "  $0 --rollback           # Undo changes"
}

# ============================================
# ARGUMENT PARSING
# ============================================
IFACE=""
DRY_RUN=false
ROLLBACK=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -i|--interface)
            IFACE="$2"
            shift 2
        ;;
        -r|--rollback)
            ROLLBACK=true
            shift
        ;;
        -d|--dry-run)
            DRY_RUN=true
            shift
        ;;
        -h|--help)
            usage
            exit 0
        ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            usage
            exit 1
        ;;
    esac
done

# ============================================
# ROLLBACK FUNCTION
# ============================================
do_rollback() {
    echo -e "${BLUE}=== Rolling back to previous settings ===${NC}"

    if [[ ! -d "$BACKUP_DIR" ]]; then
        echo -e "${RED}No backup found at $BACKUP_DIR${NC}"
        exit 1
    fi

    # Restore sysctl
    if [[ -f "$BACKUP_DIR/sysctl-backup.conf" ]]; then
        echo "Restoring sysctl settings..."
        cp "$BACKUP_DIR/sysctl-backup.conf" "$SYSCTL_FILE" 2>/dev/null || \
        rm -f "$SYSCTL_FILE"
        sysctl --system > /dev/null 2>&1
    else
        rm -f "$SYSCTL_FILE"
        sysctl --system > /dev/null 2>&1
    fi

    # Remove systemd service
    if [[ -f "$SYSTEMD_SERVICE" ]]; then
        echo "Removing tuning service..."
        systemctl disable --now nic-tuning.service 2>/dev/null || true
        rm -f "$SYSTEMD_SERVICE"
        rm -f /usr/local/bin/tune-nic.sh
        systemctl daemon-reload
    fi

    # Restore interface defaults
    if [[ -f "$BACKUP_DIR/interface" ]]; then
        IFACE=$(cat "$BACKUP_DIR/interface")
        echo "Resetting $IFACE qdisc..."
        tc qdisc replace dev "$IFACE" root fq_codel 2>/dev/null || true
    fi

    echo -e "${GREEN}Rollback complete. Reboot recommended for full reset.${NC}"
    exit 0
}

[[ "$ROLLBACK" == true ]] && do_rollback

# ============================================
# INTERFACE DETECTION
# ============================================
echo -e "${BLUE}=== 2.5G Ethernet Optimizer v${SCRIPT_VERSION} (Desktop) ===${NC}\n"

detect_interface() {
    for iface_path in /sys/class/net/*; do
        local iface_name
        iface_name=$(basename "$iface_path")

        [[ "$iface_name" == "lo" ]] && continue
        [[ ! -d "$iface_path/device" ]] && continue

        local speed
        speed=$(cat "$iface_path/speed" 2>/dev/null || echo "0")

        if [[ "$speed" == "2500" ]]; then
            echo "$iface_name"
            return 0
        fi

        if ethtool "$iface_name" 2>/dev/null | grep -qE "2500baseT|2\.5G"; then
            echo "$iface_name"
            return 0
        fi
    done
    return 1
}

if [[ -z "$IFACE" ]]; then
    echo -e "${YELLOW}[1/7] Detecting network interface...${NC}"
    IFACE=$(detect_interface) || true
fi

if [[ -z "$IFACE" ]]; then
    echo -e "${YELLOW}Could not auto-detect 2.5G interface.${NC}"
    echo "Available interfaces:"
    ip -br link show | grep -v "^lo" | awk '{print "  " $1 " (" $2 ")"}'
    echo ""
    read -p "Enter interface name: " IFACE
fi

if [[ ! -d "/sys/class/net/$IFACE" ]]; then
    echo -e "${RED}Interface $IFACE not found${NC}"
    exit 1
fi

echo -e "${GREEN}Using interface: $IFACE${NC}"

set +e
DRIVER=$(ethtool -i "$IFACE" 2>/dev/null | awk '/^driver:/ {print $2}')
set -e
DRIVER=${DRIVER:-unknown}
echo -e "Driver: $DRIVER"

if [[ "$DRIVER" == "r8169" ]]; then
    echo -e "${YELLOW}Note: r8169 has limited ethtool support. Some tuning options may not apply.${NC}"
    echo -e "${YELLOW}      For full control, consider Realtek's r8125 driver (AUR: r8125-dkms).${NC}"
fi
echo ""

# ============================================
# BACKUP
# ============================================
echo -e "${YELLOW}[2/7] Backing up current settings...${NC}"

mkdir -p "$BACKUP_DIR"
echo "$IFACE" > "$BACKUP_DIR/interface"
sysctl -a 2>/dev/null | grep -E "^net\.(core|ipv4\.tcp|ipv4\.udp)" > "$BACKUP_DIR/sysctl-current.conf" || true
[[ -f "$SYSCTL_FILE" ]] && cp "$SYSCTL_FILE" "$BACKUP_DIR/sysctl-backup.conf"
ethtool "$IFACE" > "$BACKUP_DIR/ethtool-settings.txt" 2>/dev/null || true

echo -e "${GREEN}Backup saved to $BACKUP_DIR${NC}\n"

# ============================================
# HELPER
# ============================================
run_cmd() {
    if [[ "$DRY_RUN" == true ]]; then
        echo -e "${CYAN}[DRY-RUN] $*${NC}"
    else
        "$@"
    fi
}

# ============================================
# DESKTOP PROFILE VALUES
# ============================================
TCP_RMEM="4096 262144 8388608"
TCP_WMEM="4096 262144 8388608"
RMEM_MAX=8388608
WMEM_MAX=8388608
NETDEV_BUDGET=450
NETDEV_BUDGET_USECS=3000
MAX_BACKLOG=8192
CONGESTION="bbr"
QDISC="fq_codel"
RING_BUFFER_PERCENT=75

# ============================================
# INTERFACE TUNING
# ============================================
echo -e "${YELLOW}[3/7] Tuning interface...${NC}"

# Ring buffers
echo "Configuring ring buffers..."
set +e
RX_MAX=$(ethtool -g "$IFACE" 2>/dev/null | awk '/Pre-set maximums:/,/^$/ {if (/RX:/) print $2}')
TX_MAX=$(ethtool -g "$IFACE" 2>/dev/null | awk '/Pre-set maximums:/,/^$/ {if (/TX:/) print $2}')
set -e

RX_TARGET=""
TX_TARGET=""

if [[ -n "$RX_MAX" ]] && [[ "$RX_MAX" =~ ^[0-9]+$ ]] && [[ "$RX_MAX" -gt 0 ]]; then
    RX_TARGET=$((RX_MAX * RING_BUFFER_PERCENT / 100))
    TX_TARGET=$((TX_MAX * RING_BUFFER_PERCENT / 100))
    [[ "$RX_TARGET" -lt 256 ]] && RX_TARGET=256
    [[ "$TX_TARGET" -lt 256 ]] && TX_TARGET=256

    if run_cmd ethtool -G "$IFACE" rx "$RX_TARGET" tx "$TX_TARGET" 2>/dev/null; then
        echo "  Ring buffers: RX=$RX_TARGET TX=$TX_TARGET"
    else
        echo "  Ring buffers: not supported by driver"
    fi
else
    echo "  Ring buffers: not supported by driver"
fi

# Multi-queue
echo "Configuring multi-queue..."
set +e
CHANNELS_MAX=$(ethtool -l "$IFACE" 2>/dev/null | awk '/Pre-set maximums:/ {mode=1} mode && /Combined:/ {print $2; exit}')
CHANNELS_CUR=$(ethtool -l "$IFACE" 2>/dev/null | awk '/Current hardware settings:/ {mode=1} mode && /Combined:/ {print $2; exit}')
CPU_COUNT=$(nproc)
set -e

TARGET_CHANNELS=""

if [[ -n "$CHANNELS_MAX" ]] && [[ "$CHANNELS_MAX" =~ ^[0-9]+$ ]] && [[ "$CHANNELS_MAX" -gt 1 ]]; then
    TARGET_CHANNELS=$CPU_COUNT
    [[ $TARGET_CHANNELS -gt $CHANNELS_MAX ]] && TARGET_CHANNELS=$CHANNELS_MAX
    [[ $TARGET_CHANNELS -gt 8 ]] && TARGET_CHANNELS=8

    if [[ "$CHANNELS_CUR" != "$TARGET_CHANNELS" ]]; then
        run_cmd ethtool -L "$IFACE" combined "$TARGET_CHANNELS" 2>/dev/null && \
        echo "  Channels: $TARGET_CHANNELS" || echo "  Channels: not supported"
    else
        echo "  Channels: $CHANNELS_CUR (already optimal)"
    fi
else
    echo "  Channels: not supported by driver"
fi

# Offloads
echo "Configuring offloads..."
set +e
for offload in rx tx sg tso gso gro rx-checksumming tx-checksumming; do
    ethtool -K "$IFACE" "$offload" on 2>/dev/null
done
ethtool -K "$IFACE" lro off 2>/dev/null
set -e
echo "  Offloads: enabled (LRO disabled for compatibility)"

# Coalescing
set +e
if ethtool -C "$IFACE" adaptive-rx on adaptive-tx on 2>/dev/null; then
    echo "  Coalescing: adaptive"
else
    echo "  Coalescing: driver default"
fi

# Flow control
if ethtool -A "$IFACE" rx on tx on 2>/dev/null; then
    echo "  Flow control: enabled"
else
    echo "  Flow control: not adjustable"
fi
set -e
echo ""

# ============================================
# SYSCTL
# ============================================
echo -e "${YELLOW}[4/7] Applying kernel parameters...${NC}"

# Ensure BBR module is loaded
if ! sysctl net.ipv4.tcp_available_congestion_control 2>/dev/null | grep -q bbr; then
    modprobe tcp_bbr 2>/dev/null || {
        echo -e "${YELLOW}BBR not available, falling back to cubic${NC}"
        CONGESTION="cubic"
    }
fi

if [[ "$DRY_RUN" == true ]]; then
    echo -e "${CYAN}[DRY-RUN] Would create $SYSCTL_FILE${NC}"
else
    cat > "$SYSCTL_FILE" << EOF
# 2.5G Desktop Network Tuning
# Generated: $(date)
# Interface: $IFACE

# TCP Buffer Sizes (8MB max)
net.core.rmem_max = $RMEM_MAX
net.core.wmem_max = $WMEM_MAX
net.core.rmem_default = 262144
net.core.wmem_default = 262144
net.ipv4.tcp_rmem = $TCP_RMEM
net.ipv4.tcp_wmem = $TCP_WMEM

# Network Core
net.core.netdev_budget = $NETDEV_BUDGET
net.core.netdev_budget_usecs = $NETDEV_BUDGET_USECS
net.core.netdev_max_backlog = $MAX_BACKLOG
net.core.somaxconn = 4096
net.core.optmem_max = 65536

# TCP Performance
net.ipv4.tcp_congestion_control = $CONGESTION
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_timestamps = 1
net.ipv4.tcp_sack = 1
net.ipv4.tcp_slow_start_after_idle = 0
net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_fin_timeout = 20
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_mtu_probing = 1

# BPF JIT
net.core.bpf_jit_enable = 1

# UDP (helps QUIC, gaming, streaming)
net.ipv4.udp_rmem_min = 16384
net.ipv4.udp_wmem_min = 16384
EOF

    sysctl --system > /dev/null 2>&1
fi

echo "  TCP buffers: 8MB max"
echo "  Congestion: $CONGESTION"
echo "  Netdev budget: $NETDEV_BUDGET"
echo ""

# ============================================
# QDISC
# ============================================
echo -e "${YELLOW}[5/7] Setting queue discipline...${NC}"
run_cmd tc qdisc replace dev "$IFACE" root fq_codel flows 512 2>/dev/null || \
run_cmd tc qdisc replace dev "$IFACE" root fq_codel 2>/dev/null || true
echo "  Qdisc: fq_codel (flows 512)"
echo ""

# ============================================
# PERSISTENCE
# ============================================
echo -e "${YELLOW}[6/7] Setting up persistence...${NC}"

if [[ "$DRY_RUN" == true ]]; then
    echo -e "${CYAN}[DRY-RUN] Would create systemd service${NC}"
else
    cat > /usr/local/bin/tune-nic.sh << TUNESCRIPT
#!/bin/bash
# Auto-generated NIC tuning script

IFACE="$IFACE"

for i in {1..10}; do
    [[ -d "/sys/class/net/\$IFACE" ]] && break
    sleep 0.5
done
[[ ! -d "/sys/class/net/\$IFACE" ]] && exit 1

# Ring buffers
[[ -n "${RX_TARGET:-}" ]] && ethtool -G "\$IFACE" rx "$RX_TARGET" tx "$TX_TARGET" 2>/dev/null || true

# Channels
[[ -n "${TARGET_CHANNELS:-}" ]] && ethtool -L "\$IFACE" combined "$TARGET_CHANNELS" 2>/dev/null || true

# Offloads
for off in rx tx sg tso gso gro rx-checksumming tx-checksumming; do
    ethtool -K "\$IFACE" "\$off" on 2>/dev/null || true
done
ethtool -K "\$IFACE" lro off 2>/dev/null || true

# Coalescing & flow control
ethtool -C "\$IFACE" adaptive-rx on adaptive-tx on 2>/dev/null || true
ethtool -A "\$IFACE" rx on tx on 2>/dev/null || true

# Qdisc
tc qdisc replace dev "\$IFACE" root fq_codel flows 512 2>/dev/null || \
tc qdisc replace dev "\$IFACE" root fq_codel 2>/dev/null || true

exit 0
TUNESCRIPT

    chmod +x /usr/local/bin/tune-nic.sh

    cat > "$SYSTEMD_SERVICE" << SERVICEUNIT
[Unit]
Description=NIC Performance Tuning (Desktop)
After=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/tune-nic.sh
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
SERVICEUNIT

    systemctl daemon-reload
    systemctl enable nic-tuning.service 2>/dev/null
fi

echo "  Systemd service: enabled"
echo ""

# ============================================
# IRQ CHECK
# ============================================
echo -e "${YELLOW}[7/7] Checking IRQ handling...${NC}"
if systemctl is-active --quiet irqbalance 2>/dev/null; then
    echo "  irqbalance: running ✓"
else
    echo -e "  ${YELLOW}irqbalance: not running (consider enabling it)${NC}"
fi
echo ""

# ============================================
# SUMMARY
# ============================================
echo -e "${BLUE}=== Done ===${NC}\n"

if [[ "$DRY_RUN" == true ]]; then
    echo -e "${YELLOW}DRY RUN - no changes applied${NC}"
else
    echo -e "${GREEN}Settings applied and will persist across reboots.${NC}"
    echo ""
    echo "To undo: $0 --rollback"
    echo ""
    echo "Test with:"
    echo "  iperf3 -c <server> -t 30"
    echo "  ping -c 10 <gateway>"
fi
