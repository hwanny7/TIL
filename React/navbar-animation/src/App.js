import styled from "styled-components";
import React, { useState } from "react";

const Nav = styled.div`
  height: 5vh;
  padding: 2vw;
  background: black;
  display: flex;
  justify-content: space-between;
  align-items: center;
`;

const Logo = styled.h1`
  color: white;
  margin: 0;
`;

const NavIcon = styled.button`
  background: white;
  cursor: pointer;
`;

const Overlay = styled.div`
  position: absolute;
  height: ${(props) => (props.open ? "30vh" : 0)};
  width: 100vw;
  background: #1c2022;
  transition: height 0.4s ease-in-out;
`;

const OverlayMenu = styled.ul`
  list-style: none;
  position: absolute;
  left: 50%;
  top: 45%;
  transform: translate(-50%, -50%);

  li {
    opacity: ${(props) => (props.open ? 1 : 0)};
    font-size: 25px;
    margin: 50px 0px;
    transition: opacity 0.4s ease-in-out;
  }
`;

const Link = styled.a`
  color: white;
  text-decoration: none;

  :hover {
    text-decoration: underline;
  }
`;

const Item = styled.li``;

function App() {
  const [toggle, toggleNav] = useState(false);

  return (
    <div className="App">
      <Nav>
        <Logo>Korea</Logo>
        <NavIcon onClick={() => toggleNav((prev) => !prev)}>Button</NavIcon>
      </Nav>
      <Overlay open={toggle}>
        <OverlayMenu open={toggle}>
          <Item>
            <Link target="#" href="https://www.instagram.com/igor_dumencic/">
              Instagram
            </Link>
          </Item>
          <Item>
            <Link target="#" href="https://www.behance.net/igordumencic">
              Behance
            </Link>
          </Item>
          <Item>
            <Link target="#" href="https://github.com/Igor178">
              Github
            </Link>
          </Item>
        </OverlayMenu>
      </Overlay>
    </div>
  );
}

export default App;
