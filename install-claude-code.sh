#!/bin/sh
# Optional Claude Code install, run at boot.
#
# Off unless INSTALL_CLAUDE_CODE is true, so the image stays small and a user who
# does not want it pays nothing for it.
#
# Why at boot rather than in the image: /root is a mounted volume here. The
# native installer puts the launcher in ~/.local/bin, which a build-time install
# would write into a directory the volume then hides -- `claude` would exist in
# the image and vanish on first boot. Installing after the volume is mounted puts
# it on the volume, so it survives restarts and auto-updates itself in place.
#
# Nothing in here is allowed to stop the terminal from starting. Every failure
# path prints why and returns.

set -u

case "${INSTALL_CLAUDE_CODE:-false}" in
  true|TRUE|True|1|yes|on) ;;
  *) exit 0 ;;
esac

export PATH="/root/.local/bin:$PATH"

if command -v claude >/dev/null 2>&1; then
  echo "Claude Code already installed: $(claude --version 2>/dev/null || echo present)"
  exit 0
fi

echo "INSTALL_CLAUDE_CODE is set -- installing Claude Code (one time, a minute or two)."

# Dependencies, per distro. The installer needs curl; Alpine additionally needs
# bash and the musl compatibility libraries, and its own ripgrep.
if   command -v apt-get >/dev/null 2>&1; then
  apt-get update -qq >/dev/null 2>&1 || true
  apt-get install -y -qq --no-install-recommends curl ca-certificates ripgrep >/dev/null 2>&1 || true
elif command -v apk >/dev/null 2>&1; then
  apk add --no-cache bash curl libgcc libstdc++ ripgrep >/dev/null 2>&1 || true
elif command -v tdnf >/dev/null 2>&1; then
  tdnf install -y curl ca-certificates >/dev/null 2>&1 || true
elif command -v dnf >/dev/null 2>&1; then
  dnf install -y -q curl ca-certificates >/dev/null 2>&1 || true
fi

if ! command -v curl >/dev/null 2>&1; then
  echo "Could not install curl, so Claude Code cannot be fetched. Skipping." >&2
  exit 0
fi

if ! curl -fsSL https://claude.ai/install.sh | bash; then
  echo "Claude Code install failed. The terminal is unaffected; try again with:" >&2
  echo "  curl -fsSL https://claude.ai/install.sh | bash" >&2
  exit 0
fi

# Alpine and other musl systems cannot use the bundled ripgrep.
if command -v apk >/dev/null 2>&1; then
  mkdir -p /root/.claude
  if [ ! -f /root/.claude/settings.json ]; then
    printf '{\n  "env": {\n    "USE_BUILTIN_RIPGREP": "0"\n  }\n}\n' > /root/.claude/settings.json
  fi
fi

# Put it on PATH for interactive shells, once.
if ! grep -q 'claude-code-path' /root/.bashrc 2>/dev/null; then
  {
    echo '# claude-code-path'
    echo 'export PATH="$HOME/.local/bin:$PATH"'
  } >> /root/.bashrc
fi

if command -v claude >/dev/null 2>&1; then
  echo "Claude Code installed: $(claude --version 2>/dev/null)"
  echo "Run 'claude' to start. It needs a Pro, Max, Team or Console account, or"
  echo "an ANTHROPIC_API_KEY with credit on it."
else
  echo "Installer finished but 'claude' is not on PATH yet. Open a new shell." >&2
fi

exit 0
