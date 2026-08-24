#!/bin/sh
# GoogleService-Info.plist를 앱 번들로 복사한다.
#
# **Android와 달리 iOS에는 폴더 규칙이 없다.** Android는 Gradle 플러그인이
# `google-services.json`을 알아서 처리하지만, iOS는 아무도 해 주지 않아 이 스크립트가
# 한다. Xcode의 Build Phases에 "Run Script"로 등록하며, **Copy Bundle Resources보다
# 앞에** 두어야 복사본이 번들에 들어간다.
#
# ## flavor를 보지 않는다
#
# 예전에는 dev 빌드의 번들이 `kr.ieuri.ktripspot.dev`라 Firebase 앱과 plist가 flavor별로
# 따로 있었고, 이 스크립트가 그중 하나를 골랐다. 그 접미사를 걷어내면서
# (→ `android/app/build.gradle.kts` 주석) 두 flavor의 번들이 같아졌고 콘솔의 `.dev` 앱도
# 지웠다(2026-08-25). 그래서 고를 것이 없다 — 파일 하나를 그대로 복사한다.
#
# plist의 `BUNDLE_ID`가 실제 번들과 다르면 Firebase가 런타임에 거부하므로, 파일을
# 갈아 끼울 때는 그 값을 확인한다.
set -e

SOURCE="${PROJECT_DIR}/config/GoogleService-Info.plist"

if [ ! -f "$SOURCE" ]; then
  # **빌드를 막지 않는다.** 설정 파일이 없어도 앱은 기동되고 알림만 빠진다는 것이
  # 이 저장소의 방침이다(설계 §11, PushInitializer 주석).
  echo "warning: $SOURCE 가 없어 Firebase 설정을 건너뛴다 — 앱은 알림 없이 동작한다"
  exit 0
fi

DEST="${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/GoogleService-Info.plist"
cp "$SOURCE" "$DEST"
echo "GoogleService-Info.plist ← config/"
