#!/bin/sh
# flavor에 맞는 GoogleService-Info.plist를 번들로 복사한다.
#
# **Android와 달리 iOS에는 폴더 규칙이 없다.** Android는
# `src/{flavor}/google-services.json`을 Gradle이 알아서 고르지만, iOS는 아무도
# 골라 주지 않아 이 스크립트가 한다. Xcode의 Build Phases에 "Run Script"로
# 등록하며, **Copy Bundle Resources보다 앞에** 두어야 복사본이 번들에 들어간다.
#
# 파일 배치:
#   ios/config/dev/GoogleService-Info.plist
#   ios/config/prod/GoogleService-Info.plist
#
# 둘 다 커밋하지 않는다(.gitignore) — 환경마다 다르고, CI는 시크릿에서 복원한다.
set -e

# Xcode가 넘겨주는 값. flavor를 쓰지 않고 빌드하면 비어 있다.
FLAVOR="${FLUTTER_FLAVOR}"

# `flutter build`는 FLUTTER_FLAVOR를 주지만, Xcode에서 scheme을 직접 골라
# 실행하면 비어 있을 수 있다. 그때는 빌드 구성 이름(`Debug-dev`)에서 뽑는다.
if [ -z "$FLAVOR" ]; then
  case "$CONFIGURATION" in
    *-dev)  FLAVOR="dev" ;;
    *-prod) FLAVOR="prod" ;;
  esac
fi

if [ -z "$FLAVOR" ]; then
  echo "warning: flavor를 알 수 없어 GoogleService-Info.plist를 복사하지 않는다 — 알림이 동작하지 않는다"
  exit 0
fi

SOURCE="${PROJECT_DIR}/config/${FLAVOR}/GoogleService-Info.plist"

if [ ! -f "$SOURCE" ]; then
  # **빌드를 막지 않는다.** 설정 파일이 없어도 앱은 기동되고 알림만 빠진다는 것이
  # 이 저장소의 방침이다(설계 §11, PushInitializer 주석).
  echo "warning: $SOURCE 가 없어 Firebase 설정을 건너뛴다 — 앱은 알림 없이 동작한다"
  exit 0
fi

DEST="${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/GoogleService-Info.plist"
cp "$SOURCE" "$DEST"
echo "GoogleService-Info.plist ← config/${FLAVOR}"
