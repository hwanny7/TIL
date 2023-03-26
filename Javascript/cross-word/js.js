let clues = Array.from(document.querySelectorAll("li[data-clue]"));
let index = Array.from(document.querySelector("main").children);

let state = {
  index: null,
  clue: null,
  cursor: 0,
  answers: {},
  count: 16,
};

function toggleClue() {
  // 힌트에 마우스 올려놨을 때
  let c = this.getAttribute("data-clue");
  let d = this.getAttribute("data-dir");
  let l = this.getAttribute("data-length");
  let s = index.indexOf(document.querySelector('ins[data-clue="' + c + '"]'));
  for (let x = 0; x < l; x++) {
    if (d === "across") {
      index[s + x].classList.toggle("highlight");
    } else {
      index[s + x * 12].classList.toggle("highlight");
    }
  }
}

function editClue() {
  console.log("edit clue 발동");
  Array.from(document.querySelectorAll(".cursor,.editting,.current")).map(
    (el) => {
      el.classList.remove("cursor", "editting", "current");
    }
  );
  // 그 전에 불이 들어와 있는 칸들만 제거한다

  let c = parseInt(this.getAttribute("data-clue"));
  let l = parseInt(this.getAttribute("data-length"));
  let d = this.getAttribute("data-dir");
  let s = index.indexOf(document.querySelector('ins[data-clue="' + c + '"]'));
  // 해당 커서의 clue 번호, 길이, 방향, 배열에서 index

  // 현재 클릭한 칸의 clue, 길이, 방향들을 가져온다.

  for (let x = 0; x < l; x++) {
    if (d === "across") {
      index[s + x].classList.add("editting");
    } else {
      index[s + x * 12].classList.add("editting");
    }
  }

  // 해당 커서에서부터 length만큼 불 키기, 수직의 인덱스를 만나려면 12개를 넘어야 함

  state.index = s;
  state.clue = c;
  state.dir = d;
  state.length = l;
  if (state.answers[c + "-" + d] === undefined) {
    state.answers[c + "-" + d] = "";
    state.cursor = 0;
  } else {
    if (state.length === state.answers[c + "-" + d].length) {
      state.cursor = state.answers[c + "-" + d].length - 1;
    } else {
      state.cursor = state.answers[c + "-" + d].length;
    }
  }
  // 현재 인덱스와 위치를 보고, 내가 적은 answer가 있다면 해당 지점으로 커서를 옮기고
  // 아니라면 0으로 두고 answer 칸을 만든다. 이 칸에 answer가 계속 update 될 예정
  // 만약 해당 인덱스에 알파벳이 적혀 있다면 건너 뛰어서 커서를 위치 시켜야함
  console.log(state.cursor);

  if (state.dir === "across") {
    index[s + state.cursor].classList.add("cursor");
  } else {
    index[s + state.cursor * 12].classList.add("cursor");
  }

  // 내가 클릭한 곳에 커서 애니메이션 넣기

  document
    .querySelector('li[data-clue="' + c + '"][data-dir="' + d + '"]')
    .classList.add("current");
}
// 내가 클릭한 곳의 힌트에 불 들어오게 하기

document.addEventListener(
  "keydown",
  (e) => {
    e.preventDefault();
    switch (e.key) {
      case "Shift":
      case "Space":
      case "Enter":
        return;
      case "Tab":
        console.log(state.clue, state.dir);
        let cli = document.querySelector(
          'li[data-clue="' + state.clue + '"][data-dir="' + state.dir + '"]'
        );
        console.log(cli);
        let c = clues.indexOf(cli);
        // 일치하는 값이 없으면 -1을 반환

        // 글 힌트를 통해 힌트칸의 인덱스를 찾는다
        // clues 객체만 모아놓는 배열 필요

        if (e.shiftKey === true) {
          nc = c - 1;
        } else {
          nc = c + 1;
        }

        // shift key + tap key => 뒤로 가기, tap key => 앞으로 가기

        if (nc === clues.length) {
          nc = 0;
        } else if (nc === -1) {
          nc = clues.length - 1;
        }

        // 마지막에 다 다랐을 때 0으로 변경, 그 반대일 경우 마지막 길이로 변경

        editClue.bind(clues[nc])();
        // 해당 커서로 editclue를 작동시킨다.
        return;
        break;
      case "Backspace":
        if (!state.clue) return;

        state.answers[state.clue + "-" + state.dir] = state.answers[
          state.clue + "-" + state.dir
        ].substr(0, state.answers[state.clue + "-" + state.dir].length - 1);
        // 백스페이스바를 누르면 answer 안에 담겨 있는 값을 수정하기

        break;
      default:
        if (!state.clue) return;
        if (e.key.length > 1) return;
        // caps lock 은 8 잘못된 키 입력 시
        // 키 입력 이벤트에 따라서 입력을 한다.
        if (state.answers[state.clue + "-" + state.dir].length < state.length) {
          state.answers[state.clue + "-" + state.dir] += e.key;
        }
        break;
    }

    if (state.dir === "across") {
      index[state.index + state.cursor].classList.remove("cursor");
    } else {
      index[state.index + state.cursor * 12].classList.remove("cursor");
    }
    //  cursor가 회색 깜빡이. 일단 keypress가 있으면 커서 지우고 시작하기. 마지막 장이어도 지우고 시작

    state.cursor = state.answers[state.clue + "-" + state.dir].length;
    // 내 커서의 위치 = answer에 입력한 것의 길이

    if (state.cursor < 0) {
      state.cursor = 0;
      // 입력 커서가 null 일 때?
    } else if (state.cursor > state.length - 1) {
      state.cursor = state.length - 1;
      // 입력 커서가 길이를 넘었을 때 => 여기서 정답 확인
    }
    if (state.dir === "across") {
      index[state.index + state.cursor].classList.add("cursor");
    } else {
      index[state.index + state.cursor * 12].classList.add("cursor");
    }
    // state.answers은 그 줄에서 내가 입력하고 있던 answer

    // 키프레스 한 곳으로 커서 옮기기

    for (let x = 0; x < state.length; x++) {
      if (state.dir === "across") {
        index[state.index + x].textContent =
          state.answers[state.clue + "-" + state.dir][x];
      } else {
        index[state.index + x * 12].textContent =
          state.answers[state.clue + "-" + state.dir][x];
      }
    }
    // 내가 입력한 글 적기
  },
  false
);

function selectClue() {
  console.log("selectclue 발동!", this);
  let c = parseInt(this.getAttribute("data-clue"));
  let li = Array.from(document.querySelectorAll('li[data-clue="' + c + '"]'));
  console.log(li, "li 입니다");
  if (li.length === 1) {
    editClue.bind(li[0])();
  } else {
    if (state.dir === "across") {
      editClue.bind(li[1])();
    } else {
      editClue.bind(li[0])();
    }
  }
  // 커서 칸을 클릭했을 때 해당 ins를 받아와서 clue의 데이터를 확인
  // 수직과 수평일 때에 따라 clue를 다르게 바인딩 해준다.
  // 해당 객체를 감싸는 함수를 만들면서 바로 호출한다.
  // 만약 최근에 입력한 게 있으면 해당 축의 반대로 추천을 해준다. 만약 한 개 밖에 없으면 해당 축을 추천해줌
  // 따라서 두번 클릭할 때마다 축이 바뀌는 이유
}

Array.from(document.querySelectorAll("ins[data-clue]")).map((el) => {
  el.addEventListener("click", selectClue);
});

// 힌트가 있는 칸에 모두 click 이벤트를 달아준다

clues.forEach((clue) => {
  ["mouseover", "mouseout"].map((e) => {
    clue.addEventListener(e, toggleClue);
  });
  clue.addEventListener("click", editClue);
});
// 모든 힌트 글에 마우스 올렸을 때, 내렸을 때 이벤트를 달아서 색상 toggle 해주기
