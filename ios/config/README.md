# iOS flavor별 Firebase 설정

Firebase 콘솔에서 받은 `GoogleService-Info.plist`를 여기 둔다.

```
ios/config/dev/GoogleService-Info.plist    ← 번들 id kr.ieuri.ktripspot.dev
ios/config/prod/GoogleService-Info.plist   ← 번들 id kr.ieuri.ktripspot
```

**둘을 바꿔 넣으면 안 된다.** plist 안의 `BUNDLE_ID`가 실제 번들과 다르면 Firebase가
런타임에 거부한다. 받은 파일을 열어 `BUNDLE_ID` 값을 확인하고 넣는다.

빌드할 때 `ios/scripts/copy_google_service_info.sh`가 flavor에 맞는 것을 골라 앱
번들로 복사한다. **Android와 달리 iOS에는 폴더 규칙이 없어** 그 스크립트가 필요하다.

파일 자체는 커밋하지 않는다(`.gitignore`) — 환경마다 다르고, CI는 시크릿에서
복원한다. 이 README만 커밋해 폴더 구조를 남긴다.

설정 순서 전체는 `docs/ios-flavors.md`를 본다.
