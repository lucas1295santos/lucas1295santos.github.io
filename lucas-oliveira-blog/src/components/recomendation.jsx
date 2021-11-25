import React, { Component } from "react";
import { Col } from "react-bootstrap";
import { Container } from "react-bootstrap";
import { Row } from "react-bootstrap";
import PostCard from "./postCard";
import metadata from "./metadata.json";

class Recomendation extends React.Component {
  getCards() {
    const currentPostIndex = metadata.indexOf(
      metadata.find((post) => post.postName == this.props.postName)
    );
    const nextPostIndex =
      currentPostIndex + 1 < metadata.length
        ? currentPostIndex + 1
        : currentPostIndex - 2;
    const previousPostIndex =
      currentPostIndex - 1 >= 0 ? currentPostIndex - 1 : currentPostIndex + 2;
    const recommendedPosts = [
      metadata[previousPostIndex],
      metadata[nextPostIndex],
    ];
    return recommendedPosts.map((data) => (
      <PostCard
        key={data.title}
        value={{
          title: data.title,
          abstract: data.abstract,
          date: data.date,
          ref: "post/" + data.postName,
        }}
      />
    ));
  }

  render() {
    return (
      <Container fluid style={{ backgroundColor: "whitesmoke" }}>
        <h2> More Stories </h2>
        <Row>
          <Col>{this.getCards()}</Col>
        </Row>
      </Container>
    );
  }
}

export default Recomendation;
