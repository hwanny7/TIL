import { useEffect } from "react";
const PropsComponent = ({ data }) => {
  useEffect(() => {
    console.log("데이터를 받았어요!");
  }, [data]);

  return <div>{data}</div>;
};

export default PropsComponent;
