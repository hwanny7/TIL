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
  const hightRef = useRef([]);

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

      // 이전에 켜져 있는 edit과 cursor 지우기

      const { clue } = item;
      const { length, dir } = findClue(clue, tab);

      // 수직으로 갈지 수평으로 갈지 불러오기

      let cursor = length - 1;
      for (let i = 0; i < length; i++) {
        if (dir === "across") {
          copy[i + idx] = { ...copy[i + idx], edit: true };
          if (
            state.current.answers[Math.floor(idx / 4)][(idx % 4) + i] === "" &&
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

      // across [math(index / size)][cursor]
      // down [math(index / size) + cursor][index % size]
      // 해당 축에 edit style 입히고, 만약 입력된 값이 있다면 cursor 위치 변경하기
      setWordList(copy);

      state.current = {
        ...state.current,
        index: idx,
        clue,
        dir,
        length,
        cursor,
      };

      if (state.current.dir === "across") {
        copy[state.current.index + state.current.cursor].cursor = true;
      } else {
        copy[state.current.index + state.current.cursor * 4].cursor = true;
      }

      // 해당 축에서 입력된 값이 이미 있다면 그 다음 칸으로, 아니라면 첫번째 칸에 cursor style 입히기
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
        case "ArrowUp":
        case "ArrowLeft":
        case "ArrowDown":
        case "ArrowRight":
          if (!state.current.clue) return;
          if (
            (state.current.dir === "across") &
            (e.key === "ArrowUp" || e.key === "ArrowDown")
          )
            return;
          else if (
            (state.current.dir === "down") &
            (e.key === "ArrowLeft" || e.key === "ArrowRight")
          )
            return;

          break;
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
              state.current.cursor
            ] = "";
          } else {
            state.current.answers[
              Math.floor(state.current.index / 4) + state.current.cursor
            ][state.current.index % 4] = "";
          }

          // 정답에서 해당 인덱스 지우기
          break;
        default:
          if (!state.current.clue) return;
          console.log(e.key.length);
          if (e.key.length > 1) return;
          // 클루가 없거나 이상한 키를 입력했을 때
          if (state.current.dir === "across") {
            state.current.answers[Math.floor(state.current.index / 4)][
              state.current.cursor
            ] = e.key;
          } else {
            state.current.answers[
              Math.floor(state.current.index / 4) + state.current.cursor
            ][state.current.index % 4] = e.key;
          }

          // 정답에 반영하기
          break;
      }

      // across [math(index / size)][cursor]
      // down [math(index / size) + cursor][index % size]

      let copy = [...wordList];
      const { dir, index, cursor, length, answers } = state.current;

      if (dir === "across") {
        copy[index + cursor].cursor = false;
        if (e.key.length === 9 && e.key === "Backspace") {
          copy[index + cursor].answer = "";
        } else if (e.key.length === 1) {
          copy[index + cursor].answer = e.key;
        }
      } else {
        copy[index + cursor * 4].cursor = false;
        if (e.key.length === 9 && e.key === "Backspace") {
          copy[index + cursor * 4].answer = "";
        } else if (e.key.length === 1) {
          copy[index + cursor * 4].answer = e.key;
        }
      }

      if (e.key.length === 9 && e.key === "Backspace") {
        state.current.cursor -= 1;
      } else if (e.key.length === 1) {
        state.current.cursor += 1;
        if (
          dir === "across" &&
          state.current.cursor + 1 < length &&
          answers[Math.floor(index / 4)][state.current.cursor] !== ""
        ) {
          state.current.cursor += 1;
        } else if (
          dir === "down" &&
          state.current.cursor + 1 < length &&
          answers[Math.floor(index / 4) + state.current.cursor][index % 4] !==
            ""
        ) {
          state.current.cursor += 1;
        }
        // 키 입력할 때 해당 인덱스가 채워져 있다면 다음 인덱스로 이동
      } else {
        if (e.key === "ArrowLeft") {
          state.current.cursor -= 1;
        } else if (e.key === "ArrowRight") {
          state.current.cursor += 1;
        } else if (e.key === "ArrowDown") {
          state.current.cursor += 1;
          console.log(e.key);
        } else if (e.key === "ArrowUp") {
          state.current.cursor -= 1;
        }
      }

      // 다음 커서 위치 설정 (키 입력에 따라서)

      if (state.current.cursor < 0) {
        state.current.cursor = 0;
      } else if (state.current.cursor > length - 1) {
        state.current.cursor = length - 1;
      }

      // 커서가 length 범위를 나가는 예외상황 때 수정

      if (dir === "across") {
        copy[index + state.current.cursor].cursor = true;
      } else {
        copy[index + state.current.cursor * 4].cursor = true;
      }
      console.log(copy);
      setWordList(copy);

      // 다음 커서 반영
    },
    [wordList, clueList, editClue]
  );

  useEffect(() => {
    console.log("useEffect!");
    document.addEventListener("keydown", keyPressHandler);
    return () => {
      document.removeEventListener("keydown", keyPressHandler);
    };
  }, [keyPressHandler]);

  const toggleClue = (clue) => {
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
          hightlight: !copy[index + i * 4].hightlight,
        };
      }
    }
    console.log("변경함!");
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
              style={{ marginBottom: "5vh" }}
              key={idx}
              data-clue={clue.clue}
              onMouseOver={() => toggleClue(clue)}
              onMouseOut={() => toggleClue(clue)}
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
