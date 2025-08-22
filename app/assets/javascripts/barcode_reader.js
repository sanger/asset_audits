const $ = window.jQuery || jQuery;
const CodeMirror = window.CodeMirror;

console.log("CodeMirror:", CodeMirror);

CodeMirror.defineMode("barcode_reader", function (_) {
  function tokenBase(stream, state) {
    let ch = stream.next();
    if (/\w/.test(ch)) {
      stream.eatWhile(/[\w.]/);
      let readBarcode = stream.current();
      if (state.barcodes.indexOf(readBarcode) >= 0) {
        return "strong error";
      } else {
        state.barcodes.push(readBarcode);
        return "tag";
      }
    }
  }

  return {
    startState: function () {
      return { barcodes: [] };
    },
    token: function (stream, state) {
      if (stream.eatSpace()) return null;
      let style = tokenBase(stream, state);
      return style;
    },
  };
});

$(() => {
  const sourceTubesInput = $("#robot");

  console.log("sourceTubesInput:", sourceTubesInput);

  CodeMirror.fromTextArea(sourceTubesInput, {
    lineNumbers: true,
    mode: "barcode_reader",
    theme: "eclipse",
  });
});