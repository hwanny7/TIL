import { useState } from "react";
import styled from "styled-components";

const Circle = styled.div`
  width: 100px;
  height: 100px;
  background: ${(props) => (props.$color ? "black" : "papayawhip")};
  border-radius: 50%;
`;

function App() {
  const [color, setColor] = useState(true);

  return (
    <div className="App">
      <Circle $color={color}></Circle>
      <button onClick={() => setColor((prev) => !prev)}>색상 변경</button>
    </div>
  );
}

export default App;
