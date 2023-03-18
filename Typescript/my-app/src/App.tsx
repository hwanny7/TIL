import React from "react";

interface Parent {
  lastName: string;
}

interface Child extends Parent {
  firstName: string;
}

function App() {
  const person: Child = { lastName: "Alice", firstName: "King" };

  return <div className="App"></div>;
}

export default App;
