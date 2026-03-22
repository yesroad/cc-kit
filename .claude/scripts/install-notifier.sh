#!/bin/bash
# Claude Code 보일러플레이트 초기 설정 스크립트

set -e

echo "Claude Code 알림 설정을 시작합니다..."

case "$(uname -s)" in
  Darwin*)
    # macOS: Homebrew + terminal-notifier
    if ! command -v brew &>/dev/null; then
      echo "Homebrew가 없습니다. 설치 중..."
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
      echo "Homebrew 확인 완료"
    fi

    if ! command -v terminal-notifier &>/dev/null; then
      echo "terminal-notifier 설치 중..."
      brew install terminal-notifier
    else
      echo "terminal-notifier 확인 완료"
    fi
    ;;
  Linux*)
    # Linux: libnotify (notify-send)
    if ! command -v notify-send &>/dev/null; then
      echo "libnotify 설치 중..."
      if command -v apt-get &>/dev/null; then
        sudo apt-get install -y libnotify-bin
      elif command -v dnf &>/dev/null; then
        sudo dnf install -y libnotify
      elif command -v pacman &>/dev/null; then
        sudo pacman -S --noconfirm libnotify
      else
        echo "⚠️ 패키지 매니저를 감지할 수 없습니다. libnotify를 수동으로 설치하세요."
      fi
    else
      echo "notify-send 확인 완료"
    fi
    ;;
  *)
    echo "⚠️ 지원되지 않는 OS입니다. 터미널 벨 알림만 사용됩니다."
    ;;
esac

# 훅 스크립트 실행 권한 부여
chmod +x .claude/hooks/notify.sh
echo "훅 스크립트 권한 설정 완료"

# 테스트 알림
echo "테스트 알림 발송 중..."
bash .claude/hooks/notify.sh

echo "설정 완료!"
