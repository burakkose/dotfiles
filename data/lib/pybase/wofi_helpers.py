import os
import shutil
import subprocess


LAUNCHER = os.path.expanduser("~/.bin/sway-nofullscreen-launcher")


def run(command, timeout=40, input_text=None):
    try:
        return subprocess.run(
            command,
            input=input_text,
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            timeout=timeout,
            check=False,
        )
    except subprocess.TimeoutExpired as error:
        return subprocess.CompletedProcess(error.cmd, 124, error.stdout or "")
    except OSError as error:
        return subprocess.CompletedProcess(command, 127, str(error))


def notify(summary, message, urgency="normal"):
    notifier = shutil.which("notify-send")
    if notifier:
        subprocess.run(
            [notifier, "--urgency", urgency, summary, message],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            check=False,
        )


def choose(options, prompt):
    result = run(
        [LAUNCHER, "wofi", "--dmenu", "--insensitive", "--prompt", prompt],
        input_text="\n".join(options),
    )
    return result.stdout.rstrip("\n") if result.returncode == 0 else ""


def succeeded(result):
    return result.returncode == 0 and "failed" not in result.stdout.casefold()
