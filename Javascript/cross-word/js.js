let clues = Array.from(document.querySelectorAll("li[data-clue]"));
// let index = Array.from(document.querySelector("main").children);

let state = {
  index: null,
  clue: null,
  cursor: 0,
  answers: {},
  count: 16,
};

function toggleClue() {
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
  Array.from(document.querySelectorAll(".cursor,.editting,.current")).map(
    (el) => el.classList.remove("cursor", "editting", "current")
  );

  let c = parseInt(this.getAttribute("data-clue"));
  let l = parseInt(this.getAttribute("data-length"));
  let d = this.getAttribute("data-dir");
  let s = index.indexOf(document.querySelector('ins[data-clue="' + c + '"]'));
  for (let x = 0; x < l; x++) {
    if (d === "across") {
      index[s + x].classList.add("editting");
    } else {
      index[s + x * 12].classList.add("editting");
    }
  }
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

  if (state.dir === "across") {
    index[s + state.cursor].classList.add("cursor");
  } else {
    index[s + state.cursor * 12].classList.add("cursor");
  }

  document
    .querySelector('li[data-clue="' + c + '"][data-dir="' + d + '"]')
    .classList.add("current");
}

clues.forEach((clue) => {
  ["mouseover", "mouseout"].map((e) => {
    clue.addEventListener(e, toggleClue);
  });
  clue.addEventListener("click", editClue);
});

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
        let cli = document.querySelector(
          'li[data-clue="' + state.clue + '"][data-dir="' + state.dir + '"]'
        );
        let c = clues.indexOf(cli);

        if (e.shiftKey === true) {
          nc = c - 1;
        } else {
          nc = c + 1;
        }

        if (nc === clues.length) {
          nc = 0;
        } else if (nc === -1) {
          nc = clues.length - 1;
        }

        editClue.bind(clues[nc])();
        return;
        break;
      case "Backspace":
        if (!state.clue) return;
        state.answers[state.clue + "-" + state.dir] = state.answers[
          state.clue + "-" + state.dir
        ].substr(0, state.answers[state.clue + "-" + state.dir].length - 1);
        break;
      default:
        if (!state.clue) return;
        if (e.key.length > 1) return;
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
    state.cursor = state.answers[state.clue + "-" + state.dir].length;
    if (state.cursor < 0) {
      state.cursor = 0;
    } else if (state.cursor > state.length - 1) {
      state.cursor = state.length - 1;
    }
    if (state.dir === "across") {
      index[state.index + state.cursor].classList.add("cursor");
    } else {
      index[state.index + state.cursor * 12].classList.add("cursor");
    }

    for (let x = 0; x < state.length; x++) {
      if (state.dir === "across") {
        index[state.index + x].textContent =
          state.answers[state.clue + "-" + state.dir][x];
      } else {
        index[state.index + x * 12].textContent =
          state.answers[state.clue + "-" + state.dir][x];
      }
    }
  },
  false
);

function selectClue() {
  let c = parseInt(this.getAttribute("data-clue"));
  let li = Array.from(document.querySelectorAll('li[data-clue="' + c + '"]'));
  if (li.length === 1) {
    editClue.bind(li[0])();
  } else {
    if (state.dir === "across") {
      editClue.bind(li[1])();
    } else {
      editClue.bind(li[0])();
    }
  }
}

Array.from(document.querySelectorAll("ins[data-clue]")).map((el) => {
  el.addEventListener("click", selectClue);
});
