import { useRef, useEffect, useState, useCallback } from "react";
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
    {
      box: true,
      clue: 3,
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
      clue: 4,
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
      box: true,
      clue: 0,
      answer: "",
      cursor: false,
      edit: false,
      hightlight: false,
    },
  ]);
  const [clueList, setClueList] = useState([]);
  const state = useRef({
    index: null,
    clue: null,
    cursor: 0,
    length: null,
    answers: [...Array(4)].map((e) => Array(4).fill("")),
    dir: null,
  });

  const findClue = useCallback(
    (clueNum, tab) => {
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
    },
    [clueList]
  );

  const editClue = useCallback(
    (item, idx, tab) => {
      console.log(item);
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
            copy[index + i * 4].cursor = false;
            copy[index + i * 4].edit = false;
          }
        }

        setWordList(copy);
      }
      // ================================================= 이전 하이라이팅 제거

      const { clue } = item;
      const { answer, length, dir } = findClue(clue, tab);

      let cursor = length - 1;
      for (let i = 0; i < length; i++) {
        if (dir === "across") {
          copy[i + idx] = { ...copy[i + idx], edit: true };
          if (
            state.current.answers[Math.floor(idx / 4)][(idx + i) % 4] === "" &&
            cursor === length - 1
          ) {
            cursor = i;
          }
        } else {
          copy[idx + i * 4] = { ...copy[idx + i * 4], edit: true };
          if (
            state.current.answers[Math.floor(idx / 4 + i)][idx % 4] === "" &&
            cursor === length - 1
          ) {
            cursor = i;
          }
        }
      }
      setWordList(copy);

      state.current = {
        ...state.current,
        index: idx,
        clue,
        dir,
        length,
        cursor,
      };

      // if (state.current.answers[clue + "-" + dir] === undefined) {
      //   state.current.answers[clue + "-" + dir] = "";
      //   state.current.cursor = 0;
      // } else {
      //   if (
      //     state.current.length ===
      //     state.current.answers[clue + "-" + dir].length
      //   ) {
      //     state.current.cursor =
      //       state.current.answers[clue + "-" + dir].length - 1;
      //   } else {
      //     state.current.cursor = state.current.answers[clue + "-" + dir].length;
      //   } // 해당 인덱스에 알파벳이 적혀 있는지 확인 후 있다면 건너 뛴다.
      // }

      //========================================================================

      if (state.current.dir === "across") {
        copy[state.current.index + state.current.cursor].cursor = true;
      } else {
        copy[state.current.index + state.current.cursor * 4].cursor = true;
      }
    },
    [wordList, findClue]
  );

  useEffect(() => {
    setClueList([
      {
        clue: 1,
        answer: "dog",
        length: 3,
        dir: "across",
        index: 0,
        content: "애완동물",
      },
      {
        clue: 2,
        answer: "oman",
        length: 4,
        dir: "down",
        index: 1,
        content: "아랍에미레이트 옆에 국가",
      },
      {
        clue: 3,
        answer: "daum",
        length: 4,
        dir: "across",
        index: 8,
        content: "네이버 전에 잘나가던",
      },
      {
        clue: 4,
        answer: "ma",
        length: 2,
        dir: "down",
        index: 11,
        content: "ma",
      },
    ]);
  }, []);

  const keyPressHandler = useCallback(
    (e) => {
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

          editClue(
            wordList[clueList[nextIndex].index],
            clueList[nextIndex].index,
            clueList[nextIndex]
          );

          return;
        case "Backspace":
          if (!state.current.clue) return;

          if (state.current.dir === "across") {
            state.current.answers[Math.floor(state.current.index / 4)][
              (state.current.index + state.current.cursor) % 4
            ] = "";
          } else {
            state.current.answers[
              Math.floor(state.current.index / 4 + state.current.cursor)
            ][state.current.index % 4] = "";
          }
          console.log(
            state.current.answers,
            "백스페이스바",
            state.current.cursor
          );

          break;
        default:
          if (!state.current.clue) return;
          // clue를 클릭하지 않고, 입력했을 때
          if (e.key.length > 1) return;

          if (state.current.dir === "across") {
            state.current.answers[Math.floor(state.current.index / 4)][
              (state.current.index + state.current.cursor) % 4
            ] = e.key;
          } else {
            state.current.answers[
              Math.floor(state.current.index / 4 + state.current.cursor)
            ][state.current.index % 4] = e.key;
          }

          console.log(state.current.answers, "입력", state.current.cursor);
          break;
      }

      console.log(state.current.answers);
      let copy = [...wordList];

      if (state.current.dir === "across") {
        copy[state.current.index + state.current.cursor].cursor = false;
        if (e.key.length === 9) {
          copy[state.current.index + state.current.cursor].answer = "";
        } else {
          copy[state.current.index + state.current.cursor].answer = e.key;
        }
      } else {
        copy[state.current.index + state.current.cursor * 4].cursor = false;
        if (e.key.length === 9) {
          copy[state.current.index + state.current.cursor * 4].answer = "";
        } else {
          copy[state.current.index + state.current.cursor * 4].answer = e.key;
        }
      }

      if (e.key.length === 9) {
        state.current.cursor -= 1;
      } else {
        state.current.cursor += 1;
      }

      if (state.current.cursor < 0) {
        state.current.cursor = 0;
      } else if (state.current.cursor > state.current.length - 1) {
        state.current.cursor = state.current.length - 1;
      }

      if (state.current.dir === "across") {
        copy[state.current.index + state.current.cursor].cursor = true;
      } else {
        copy[state.current.index + state.current.cursor * 4].cursor = true;
      }
      setWordList(copy);
    },
    [wordList, clueList, editClue]
  );

  useEffect(() => {
    console.log("재렌더링!");
    document.addEventListener("keydown", keyPressHandler);
    return () => {
      document.removeEventListener("keydown", keyPressHandler);
    };
  }, [keyPressHandler]);

  const toggleClue = async (clue) => {
    const { index, dir, length } = clue;
    let copy = [...wordList];
    for (let i = 0; i < length; i++) {
      if (dir === "across") {
        copy[i + index] = {
          ...copy[i + index],
          hightlight: !copy[i + index].hightlight,
        };
      } else {
        copy[index + i * 4] = {
          ...copy[index + i * 4],
          hightlight: !copy[i + index].hightlight,
        };
      }
    }
    setWordList(copy);
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
        {clueList.map((clue, idx) => {
          return (
            <li
              key={idx}
              data-clue={clue.clue}
              // onMouseOver={() => toggleClue(clue)}
              // onMouseOut={() => toggleClue(clue)}
            >
              {idx + ".  " + clue.content}
            </li>
          );
        })}
      </ul>
      <ul>
        <li className="heading">Across</li>
        <li data-clue="1" data-dir="across" data-length="2">
          1. Horizontal viewport unit (2)
        </li>
        <li data-clue="4" data-dir="across" data-length="3">
          4. A line in the grid (3)
        </li>
      </ul>
    </div>
  );
}

export default App;
