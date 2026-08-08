> spec: SPEC-0012 · source: `specs/SPEC-0012/spec.md` (Obsidian) · status: draft

# SPEC-0012 클라이언트 설계 — SNS authorization code 전달

요구사항과 수용 기준은 스펙이 권위를 가진다. 이 문서는 클라이언트가 그것을 어떻게 실현하는지만 다룬다.

이 스펙의 클라이언트 작업은 **R4와 R7 두 가지뿐**이다. 화면 변경이 없다.

## 1. 작업의 성질

SNS 인증 결과에서 authorization code를 꺼내 가입·로그인 요청에 함께 보낸다. 사용자에게 보이는 변화는 없고, 새 화면도 새 상태도 없다.

기존 SNS 인증은 provider SDK에서 `id_token`만 꺼내 `SnsCredential`로 감싼다. 여기에 code를 하나 더 담는다.

## 2. provider별 code 획득

세 provider가 각각 다른 이름으로 노출한다. **획득 방식을 SDK 문서로 확인해야 한다** — 아래는 조사 시작점이지 확정된 사실이 아니다.

| provider | 예상 필드 | 확인 필요 |
|---|---|---|
| Apple | `authorizationCode` | Sign in with Apple 응답에 포함. 인코딩 형태 확인 |
| Google | `serverAuthCode` | 요청 시 서버 클라이언트 ID를 지정해야 발급되는 경우가 있다 |
| Kakao | 미확인 | OIDC 흐름에서 code를 노출하는지, 아니면 SDK가 이미 소비하는지 |

구글은 특히 주의가 필요하다. `serverAuthCode`는 로그인 요청 시 서버용 클라이언트 ID를 함께 지정해야 내려오는 경우가 있어, **인증 요청 구성 자체를 바꿔야 할 수 있다.**

카카오는 서버가 어드민 키 경로를 택하면 code 자체가 불필요해질 수 있다. 서버 설계 문서의 확인 사항과 맞물리므로 서버 쪽 결론을 기다린 뒤 대응한다.

code는 일회용이고 짧게 만료된다. 획득 즉시 요청에 실어 보내고 저장하지 않는다.

## 3. 모델과 전달 경로

`SnsCredential`에 code 필드를 더한다. nullable이다 — provider가 주지 않는 경우가 정상 경로에 있다(R4 세 번째 기준).

전달 지점은 두 곳이다.

- **SNS 가입** — `SnsSignUpScreen`이 `signUpSns`를 호출할 때. 이미 `SnsCredential`을 들고 있으므로 repository까지 값이 흐르게만 하면 된다
- **SNS 로그인** — 로그인 요청 시. 여기가 핵심이다. 클라이언트 업데이트 전에 가입한 회원은 토큰이 없고, **다음 로그인 때 보충**되기 때문이다

로그인 경로를 빠뜨리면 기존 회원이 영영 revoke 대상이 되지 못한다. 가입 경로만 넣는 실수를 주의한다.

## 4. 실패 처리 (R7)

code를 얻지 못해도 **가입·로그인 흐름을 막지 않는다.** 오류를 표시하지 않고, 재시도를 요구하지 않고, 요청을 보류하지 않는다.

`authorizationCode`는 계약에서 nullable이다. 값이 없으면 필드를 비워 보내면 되고 서버가 토큰을 보충하지 않을 뿐이다.

이것이 이 스펙에서 가장 어기기 쉬운 요구사항이다. code 획득 실패를 인증 실패로 취급하는 방어 코드를 넣으면 R7 위반이며, 사용자는 로그인이 안 되는 이유를 알 수 없다. **code 획득은 인증 흐름의 곁가지**이며 실패가 본류에 전파되어서는 안 된다.

## 5. 단위 테스트 대상

provider/notifier와 도메인 모델 로직만. 위젯·통합 테스트는 범위 밖이다(CLAUDE.md 테스트 범위표).

| 단위 | 검증 |
|---|---|
| SNS 인증 결과 매핑 | code가 있을 때 `SnsCredential`에 담김 (R4) |
| SNS 인증 결과 매핑 | code가 없을 때 null로 담기고 예외가 아님 (R4·R7) |
| 가입 요청 구성 | `SnsCredential`의 code가 요청에 포함됨 (R4) |
| 로그인 요청 구성 | code가 요청에 포함됨 (R4) |
| 로그인 요청 구성 | code가 null일 때 `authorizationCode`가 비어 있는 요청이 구성됨 (R4) |
| 인증 컨트롤러 | code 획득 실패 시에도 로그인 성공 상태로 전이 (R7) |

provider SDK는 포트로 스텁한다. **SDK가 실제로 code를 반환하는지는 단위 테스트로 확인할 수 없다** — 실기기와 provider 계정이 필요한 인프라 영역이다. 매핑 로직까지만 테스트하고, 실제 획득 여부는 실행 환경에서 확인한다.

## 6. 계약 소비

생성 GraphQL 타입은 repository 레이어를 넘지 않는다. `authorizationCode`는 요청 입력 필드이므로 도메인 모델(`SnsCredential`)에서 repository로 내려가는 방향이며 기존 경계를 유지한다.

## 7. 확인 사항

- 세 provider SDK가 authorization code를 노출하는 실제 필드명과 획득 조건
- 구글이 `serverAuthCode`를 받기 위해 인증 요청 구성을 바꿔야 하는지
- 카카오가 code를 노출하는지, 아니면 서버의 어드민 키 경로로 대체되어 클라이언트 작업이 불필요한지
