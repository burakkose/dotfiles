for i in $(find . -name "*.ovpn");
do
  nmcli connection import type openvpn file $i;
done
