# NOWNESS
</br>

### 1. 주제
> 실시간 현장 상황 공유
> 
> 현장(특정 장소, 공연, 축제 등)의 실시간 상황을 공유하여, 여가 및 휴식에 대한 피로도를 줄이고 만족도를 높임

</br>

### 2. 제작 기간
> 23.06.26 ~ 08.09

</br>

### 3. 참여 인원
> 팀장: 황윤섭
> 
> 팀원: 오OO, 이OO, 정OO, 차OO

</br>

### 4. 기술 및 도구
> Java 17, Spring/ Spring Boot 3.1.1, Spring Security 6.1.1, Gradle 7.6.1, MySQL 8.0, MyBatis 3.0.2, Thymeleaf, BootStrap, IntelliJ
</br>

### 5. ERD 설계
![](https://github.com/hyseop/NOWNESS/blob/main/NOWNESS%20ERD.png)

</br>

### 6. 담당 파트 기능
> 메인 화면 페이지 구성
> 
> > 카카오 지도 API 활용  
> > 🔗[1](https://github.com/hyseop/NOWNESS/blob/main/src/main/resources/static/js/main/map.js), [2](https://github.com/hyseop/NOWNESS/blob/main/src/main/resources/static/css/main/map.css)
> > 
> > 오픈 채팅, 웹소켓  
> > 🔗[1](https://github.com/hyseop/NOWNESS/blob/main/src/main/java/highfive/nowness/controller/ChatController.java), [2](https://github.com/hyseop/NOWNESS/blob/main/src/main/java/highfive/nowness/config/WebSocketConfig.java), [3](https://github.com/hyseop/NOWNESS/blob/main/src/main/java/highfive/nowness/dto/ChatMessage.java), [4](https://github.com/hyseop/NOWNESS/blob/main/src/main/resources/static/css/main/chat.css), [5](https://github.com/hyseop/NOWNESS/blob/main/src/main/resources/static/js/main/chat.js)
> > 
> > 텍스트 캐러셀, 헤더 및 푸터  
> > 🔗[1](https://github.com/hyseop/NOWNESS/blob/main/src/main/java/highfive/nowness/controller/MainController.java), [2](https://github.com/hyseop/NOWNESS/blob/main/src/main/resources/templates/main.html), [3](https://github.com/hyseop/NOWNESS/blob/main/src/main/resources/static/css/main/main.css), [4](https://github.com/hyseop/NOWNESS/blob/main/src/main/resources/templates/header.html), [5](https://github.com/hyseop/NOWNESS/blob/main/src/main/resources/templates/footer.html)

</br>

### 7. 회고
> 팀장의 부담감과 책임감, 또 반복된 욕심, 또 미완성된 아쉬
>
> > 👎
> > 인텔리제이, 타임리프 등 미학습 툴과 템플릿을 사용하고자 했던 욕심으로 인해 전체적으로 프로젝트 완성도가 떨어짐 
> > 
> > 2
> > 
> > 3  
> >
> > 👍
> > 1
> > 
> > 2
> > 
> > 3
> >
> > 
