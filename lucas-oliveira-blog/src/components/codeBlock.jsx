import React, { Component } from "react";
// import SyntaxHighlighter from "react-syntax-highlighter";
// import { atomOneLight } from "react-syntax-highlighter";
import { dracula } from "react-syntax-highlighter/dist/esm/styles/hljs";
import PropTypes from "prop-types";

// class CodeBlock extends Component {
//   render() {
//     return (
//       <SyntaxHighlighter language="swift" style={dracula}>
//         {this.props.code}
//       </SyntaxHighlighter>
//     );
//   }
// }

import { Prism as SyntaxHighlighter } from "react-syntax-highlighter";
import { dark } from "react-syntax-highlighter/dist/esm/styles/prism";

const CodeBlock = () => {
  const codeString = "(num) => num + 1";
  return (
    <SyntaxHighlighter language="swift" style={dark}>
      {codeString}
    </SyntaxHighlighter>
  );
};

export default CodeBlock;
