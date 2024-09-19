# Aoi: 일본 상용한자 학습
> 일본에서 자주 사용되는 상용한자를 학습하는데 도움을 줍니다.

![Cover](https://github.com/user-attachments/assets/0ad6798c-2e2c-4e5d-938e-e533b6083b72)
(https://apps.apple.com/kr/app/aoi-%EC%9D%BC%EB%B3%B8-%EC%83%81%EC%9A%A9%ED%95%9C%EC%9E%90-%ED%95%99%EC%8A%B5/id6554000732)
## 📖 Description
일본 문부과학성에서 지정한 2136개의 상용한자를 학습하기 위해 만들어진 앱입니다.

주요 기능
- 매일 달라지는 추천 한자
- 초등학교, 중학교 학년 별로 학습 및 퀴즈로 공부하기
- 한자 검색 기능
- 학습이 잘 안되거나 모아서 공부하고 싶은 한자들을 북마크할 수 있습니다.
- 북마크된 한자들을 퀴즈로 공부할 수 있습니다.

## Screenshot
![image](https://github.com/user-attachments/assets/f82dd551-74bb-4879-a4b1-bab44328c340)

## 프로젝트 구조
```
.
├── Application
│   ├── DIContainer.swift
│   └── LearningKanjiApp.swift
├── Data
│   ├── DataMapping
│   ├── Repositories
│   └── Storages
├── Domain
│   ├── Entities
│   ├── Port
│   └── Services
├── Info.plist
├── Presentation
│   ├── Bookmarks
│   ├── ContentView.swift
│   ├── Home
│   ├── LearningAtQuiz
│   ├── LearningKanji
│   ├── SearchKanji
│   ├── Settings
│   └── Util
└── Resources
```
