import PropsComponent from "./PropsComponent";
import { useEffect, useState } from "react";

function App() {
  const [data, setData] = useState("5초 전");

  useEffect(() => {
    setTimeout(() => {
      setData("5초 후");
    }, 5000);
  }, []);

  return (
    <div>
      {data === "5초 후" && <PropsComponent data={data}></PropsComponent>}
    </div>
  );
}

export default App;
