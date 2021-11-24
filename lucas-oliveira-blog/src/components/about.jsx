import React, { Component } from "react";
import { Image, Row, Col, Container } from "react-bootstrap";
import "../about.css";

class About extends React.Component {
  render() {
    return (
      <Container fluid className="about">
        <Row>
          <Col>
            <Image src="about.jpg" thumbnail />
          </Col>
          <Col>
            <h1>Hello, I'm Lucas Oliveira dos Santos</h1>
            <p>
              I found my passion for app development at the Apple Developer
              Academy in 2017, when I learned iOS app development. Coming from a
              background of C# and C++, I instantly fell in love with Swift.
            </p>
            <p>
              I got my first iOS developer job at{" "}
              <a href="https://www.ifood.com.br/">iFood</a> in 2018, where I
              learned that up until that point I had just scratched the tip of
              the iceberg on software engineering. Which was both exciting and
              daunting.
            </p>
            <p>
              After three years of working on the biggest food delivery app in
              Latin America, I learned a lot about scaling mobile applications,
              mobile architecture, best practices, and much more.
            </p>
            <p>
              In November 2021, I've joined{" "}
              <a href="https://www.faire.com/">Faire</a> as an iOS Engineer.
            </p>
            <p>
              Beyond iOS development, I like to always have some side-project
              with a technology that is new to me. I'm learning React by making
              this blog, and Kotlin by creating some simple web applications
              with Ktor.
            </p>
            <p>
              Throughout this journey, I had great mentors and teachers by my
              side. This blog is my way of giving back a little bit of that.
            </p>
            <h3>Contact</h3>
            <p>Feel free to connect with me through any of these:</p>
            <ul>
              <li>
                <a href="https://twitter.com/oliveira__lucas">Twitter</a>
              </li>
              <li>
                <a href="https://github.com/lucas1295santos">Github</a>
              </li>
              <li>
                <a href="https://www.linkedin.com/in/lucas-santos-168769106/">
                  Linkedin
                </a>
              </li>
              <li>
                <a>Email: lucas1295santos@gmail.com</a>
              </li>
            </ul>
            <p></p>
          </Col>
        </Row>
      </Container>
    );
  }
}

export default About;
