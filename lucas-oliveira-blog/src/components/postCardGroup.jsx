import React, { Component } from "react";
import { CardGroup, Col } from "react-bootstrap";
import { Container } from "react-bootstrap";
import { Row } from "react-bootstrap";
import PostCard from "./postCard";

class PostCardGroup extends React.Component {
  render() {
    return (
      <Container>
        <Row>
          <Col>
            <PostCard />
            <PostCard />
            <PostCard />
            <PostCard />
          </Col>
        </Row>
      </Container>
    );
  }
}

export default PostCardGroup;
