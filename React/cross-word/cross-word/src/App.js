import { useRef, useEffect, useState } from "react";
import "./App.css";
import cx from "classnames";

function App() {
  const [wordList, setWordList] = useState([
    {
      box: true,
      clue: 1,
      answer: "",
      cursor: false,
      edit: false,
      hightlight: false,
    },
    {
      box: true,
      clue: 0,
      answer: "",
      cursor: false,
      edit: false,
      hightlight: false,
    },
    {
      box: true,
      clue: 0,
      answer: "",
      cursor: false,
      edit: false,
      hightlight: false,
    },
    {
      box: true,
      clue: 2,
      answer: "",
      cursor: false,
      edit: false,
      hightlight: false,
    },
    {
      box: true,
      clue: 0,
      answer: "",
      cursor: false,
      edit: false,
      hightlight: false,
    },
    {
      box: true,
      clue: 0,
      answer: "",
      cursor: false,
      edit: false,
      hightlight: false,
    },
    {
      box: true,
      clue: 0,
      answer: "",
      cursor: false,
      edit: false,
      hightlight: false,
    },
    {
      box: false,
      clue: 0,
      answer: "",
      cursor: false,
      edit: false,
      hightlight: false,
    },
    {
      box: false,
      clue: 0,
      answer: "",
      cursor: false,
      edit: false,
      hightlight: false,
    },
  ]);
  const clueList = [
    { clue: 1, answer: "dog", length: 3, dir: "across", index: 0 },
    { clue: 2, answer: "cat", length: 3, dir: "across", index: 3 },
    { clue: 1, answer: "dog", length: 3, dir: "down", index: 0 },
  ];
  const copyRef = useRef(null);
  const state = useRef({
    index: null,
    clue: null,
    cursor: 0,
    length: null,
    answers: {},
    dir: null,
  });

  useEffect(() => {
    const keyPressHandler = (e) => {
      e.preventDefault();
      switch (e.key) {
        case "Shift":
        case "Space":
        case "Enter":
          return;
        case "Tab":
          let nextIndex;
          if (!state.current.clue) {
            nextIndex = -1;
          } else {
            clueList.forEach((element, idx) => {
              if (
                element.clue === state.current.clue &&
                element.dir === state.current.dir
              ) {
                nextIndex = idx;
                return false;
              }
            });
          }

          if (e.shiftKey === true) {
            nextIndex -= 1;
          } else {
            nextIndex += 1;
          }

          // shift key + tap key => 뒤로 가기, tap key => 앞으로 가기

          if (nextIndex === clueList.length) {
            nextIndex = 0;
          } else if (nextIndex < 0) {
            nextIndex = clueList.length - 1;
          }
          console.log(nextIndex, "next");
          editClue(
            wordList[clueList[nextIndex].index],
            clueList[nextIndex].index,
            clueList[nextIndex]
          );

          return;
        case "Backspace":
          if (!state.current.clue) return;
          state.current.answers[state.current.clue + "-" + state.current.dir] =
            state.current.answers[
              state.current.clue + "-" + state.current.dir
            ].substr(
              0,
              state.current.answers[
                state.current.clue + "-" + state.current.dir
              ].length - 1
            );
          // 일단 answer에서 지우고 default를 통과하고 그 밑에서 해결한다

          break;
        default:
          if (!state.current.clue) return;
          // clue를 클릭하지 않고, 입력했을 때
          if (e.key.length > 1) return;
          if (
            state.current.answers[state.current.clue + "-" + state.current.dir]
              .length < state.current.length
          ) {
            state.current.answers[
              state.current.clue + "-" + state.current.dir
            ] += e.key;
            // 밑에서 cursor 위치 바꿀 때 입력 길이 확인함
          }
          break;
      }
      let copy = [...copyRef.current];
      if (state.current.dir === "across") {
        copy[state.current.index + state.current.cursor].cursor = false;
        if (e.key.length === 9) {
          copy[state.current.index + state.current.cursor].answer = "";
        } else {
          copy[state.current.index + state.current.cursor].answer = e.key;
        }
      } else {
        copy[state.current.index + state.current.cursor * 3].cursor = false;
        if (e.key.length === 9) {
          copy[state.current.index + state.current.cursor * 3].answer = "";
        } else {
          copy[state.current.index + state.current.cursor * 3].answer = e.key;
        }
      }
      state.current.cursor =
        state.current.answers[
          state.current.clue + "-" + state.current.dir
        ].length;
      if (e.key.length === 9) {
        state.current.cursor -= 1;
      }

      if (state.current.cursor < 0) {
        state.current.cursor = 0;

        // 입력 커서가 0보다 작아지는 경우가 있나?
      } else if (state.current.cursor > state.current.length - 1) {
        state.current.cursor = state.current.length - 1;
      }
      if (state.current.dir === "across") {
        copy[state.current.index + state.current.cursor].cursor = true;
      } else {
        copy[state.current.index + state.current.cursor * 3].cursor = true;
      }
      copyRef.current = copy;
      setWordList(copy);
    };

    document.addEventListener("keydown", keyPressHandler);
    return () => {
      document.removeEventListener("keydown", keyPressHandler);
    };
  }, []);

  const findClue = (clueNum, tab) => {
    if (tab) {
      return tab;
    }
    const clues = clueList.filter((item) => {
      return item.clue === clueNum;
    });
    if (clues.length === 1) {
      return clues[0];
    } else if (state.current.clue === clues[0].clue) {
      return state.current.dir === "across" ? clues[1] : clues[0];
    } else {
      return clues[0];
    }
  };

  const editClue = (item, idx, tab) => {
    let copy = [...wordList];
    if (state.current.clue) {
      const index = state.current.index;
      if (state.current.dir === "across") {
        for (let i = 0; i < state.current.length; i++) {
          copy[i + index].cursor = false;
          copy[i + index].edit = false;
        }
      } else {
        for (let i = 0; i < state.current.length; i++) {
          copy[index + i * 3].cursor = false;
          copy[index + i * 3].edit = false;
        }
      }

      setWordList(copy);
    }
    // ================================================= 이전 하이라이팅 제거

    const { clue } = item;
    const { answer, length, dir } = findClue(clue, tab);

    for (let i = 0; i < length; i++) {
      if (dir === "across") {
        copy[i + idx] = { ...wordList[i + idx], edit: true };
      } else {
        copy[idx + i * 3] = { ...wordList[idx + i * 3], edit: true };
      }
    }
    setWordList(copy);
    copyRef.current = copy;
    state.current = { ...state.current, index: idx, clue, dir, length };

    if (state.current.answers[clue + "-" + dir] === undefined) {
      state.current.answers[clue + "-" + dir] = "";
      state.current.cursor = 0;
    } else {
      if (
        state.current.length === state.current.answers[clue + "-" + dir].length
      ) {
        state.current.cursor =
          state.current.answers[clue + "-" + dir].length - 1;
      } else {
        state.current.cursor = state.current.answers[clue + "-" + dir].length;
      } // 해당 인덱스에 알파벳이 적혀 있는지 확인 후 있다면 건너 뛴다.
    }

    if (state.current.dir === "across") {
      copy[state.current.index + state.current.cursor].cursor = true;
    } else {
      copy[state.current.index + state.current.cursor * 3].cursor = true;
    }

    // 클릭하면 커서, edit 기능만 하는 구간
    // setWordList(copy);??

    // 힌트에 불 들어오게 하는 로직 짜기
  };

  return (
    <div className="grid">
      <main>
        {wordList.map((word, idx) => {
          if (word.clue) {
            return (
              <ins
                key={idx}
                data-clue={word.clue}
                onClick={() => editClue(word, idx)}
                className={cx({
                  cursor: word.cursor,
                  editting: word.edit,
                  highlight: word.hightlight,
                })}
              >
                {word.answer}
              </ins>
            );
          } else if (word.box) {
            return (
              <ins
                key={idx}
                className={cx({
                  cursor: word.cursor,
                  editting: word.edit,
                  highlight: word.hightlight,
                })}
              >
                {word.answer}
              </ins>
            );
          } else {
            return <del key={idx}></del>;
          }
        })}
      </main>
      <ul>
        <li className="heading">Across</li>
        <li data-clue="1" data-dir="across" data-length="2">
          1. Horizontal viewport unit (2)
        </li>
        <li data-clue="4" data-dir="across" data-length="3">
          4. A line in the grid (3)
        </li>
        <li data-clue="6" data-dir="across" data-length="6">
          6. Removed from the DOM (6)
        </li>
        <li data-clue="8" data-dir="across" data-length="3">
          8. child, of-type, etc (3)
        </li>
        <li data-clue="9" data-dir="across" data-length="5">
          9. Post, pseudo element (5)
        </li>
        <li data-clue="10" data-dir="across" data-length="4">
          10. CSS layout tech (4)
        </li>
        <li data-clue="11" data-dir="across" data-length="4">
          11. Named layout group (4)
        </li>
        <li data-clue="13" data-dir="across" data-length="5">
          13. Text hue (5)
        </li>
        <li data-clue="15" data-dir="across" data-length="11">
          15. No color (11)
        </li>
      </ul>

      <ul>
        <li className="heading">Down</li>
        <li data-clue="1" data-dir="down" data-length="2">
          1. Vertical viewport unit (2)
        </li>
        <li data-clue="2" data-dir="down" data-length="5">
          2. Fixed horizontal length (5)
        </li>
        <li data-clue="3" data-dir="down" data-length="8">
          3. Positioned in parent's frame (8)
        </li>
        <li data-clue="5" data-dir="down" data-length="11">
          5. Text display direction (7,4)
        </li>
        <li data-clue="7" data-dir="down" data-length="6">
          7. Around the outside (6)
        </li>
        <li data-clue="10" data-dir="down" data-length="3">
          10. Space between elements (3)
        </li>
        <li data-clue="12" data-dir="down" data-length="5">
          12. Opposite of left (5)
        </li>
        <li data-clue="14" data-dir="down" data-length="3">
          14. Alternative angle unit (3)
        </li>
        <li data-clue="16" data-dir="down" data-length="2">
          16. Pica unit (2)
        </li>
      </ul>

      <p>Click on a clue or press TAB. Type your answers.</p>
    </div>
  );
}

export default App;
