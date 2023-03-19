import React from "react";
import { useEffect, useState } from "react";

const Com = ({ data }) => {
  const [props, setProps] = useState();

  useEffect(() => {
    setProps(data + 2);
  }, [data]);

  return <div>{data}</div>;
};

export default Com;
