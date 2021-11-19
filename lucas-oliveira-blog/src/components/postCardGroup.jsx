import React, { Component } from "react";
import { Col } from "react-bootstrap";
import { Container } from "react-bootstrap";
import { Row } from "react-bootstrap";
import PostCard from "./postCard";
import postPath from "../assetHelper";
import metadata from "./metadata.json";

class PostCardGroup extends React.Component {
  state = {};
  getCards() {
    return metadata.map((data) => (
      <PostCard
        key={data.title}
        value={{
          title: data.title,
          abstract: data.abstract,
          date: data.date,
          ref: postPath(data.postName),
        }}
      />
    ));
  }

  render() {
    return (
      <Container>
        <Row>
          <Col>{this.getCards()}</Col>
        </Row>
      </Container>
    );
  }
}

export default PostCardGroup;
