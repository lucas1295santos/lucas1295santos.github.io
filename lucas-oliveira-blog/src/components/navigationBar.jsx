import React, { Component } from "react";
import { Navbar } from "react-bootstrap";
import { Nav } from "react-bootstrap";
import { Container } from "react-bootstrap";
import { SocialIcon } from "react-social-icons";
import { Link } from "react-router-dom";

class NavigationBar extends React.Component {
  render() {
    return (
      <Navbar bg="light" expand="lg" sticky="top" style={{ width: "100%" }}>
        <Container>
          <Navbar.Brand>
            <Link to="/">Lucas Oliveira's Blog</Link>
          </Navbar.Brand>
          <Navbar.Toggle aria-controls="basic-navbar-nav" />
          <Navbar.Collapse id="basic-navbar-nav">
            <Nav>
              <Nav.Link>
                <Link to="/">Home</Link>
              </Nav.Link>
              <Nav.Link>
                <Link to="/about">About</Link>
              </Nav.Link>
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
