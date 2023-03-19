import Com from "./Com";
import { useState } from "react";

function App() {
  const [data, setData] = useState(0);

  return (
    <div className="App">
      <button onClick={() => setData((prev) => prev + 1)}>+</button>
      <Com data={data}></Com>
    </div>
  );
}

export default App;
