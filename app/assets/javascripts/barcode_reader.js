CodeMirror.defineMode("barcode_reader", function (_) {
  function tokenBase(stream, state) {
    console.log(stream);
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
  const sourceTubesInput = $("#barcode_text");
  const robot_input = $("#robot_input");

  var editor = CodeMirror.fromTextArea(sourceTubesInput[0], {
    lineNumbers: true,
    mode: "barcode_reader",
    theme: "eclipse",
  });

  editor.on("change", function (cm, change) {
    robot_input.val(cm.getValue());
  });
});
