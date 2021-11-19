import React, { Component } from "react";
import { Navbar } from "react-bootstrap";
import { Nav } from "react-bootstrap";
import { Container } from "react-bootstrap";
import { SocialIcon } from "react-social-icons";

class NavigationBar extends React.Component {
  render() {
    return (
      <Navbar bg="light" expand="lg" sticky="top" style={{ width: "100%" }}>
        <Container>
          <Navbar.Brand href="#home">Lucas Oliveira's blog</Navbar.Brand>
          <Navbar.Toggle aria-controls="basic-navbar-nav" />
          <Navbar.Collapse id="basic-navbar-nav">
            <Nav>
              <Nav.Link href="#home">Home</Nav.Link>
              <Nav.Link href="#about">About</Nav.Link>
            </Nav>
            <Nav className="ms-auto">
              <Nav.Item className="mx-1">
                <SocialIcon url="https://twitter.com/oliveira__lucas" />
              </Nav.Item>
              <Nav.Item className="mx-1">
                <SocialIcon url="https://github.com/lucas1295santos" />
              </Nav.Item>
            </Nav>
          </Navbar.Collapse>
        </Container>
      </Navbar>
    );
  }
}

export default NavigationBar;
