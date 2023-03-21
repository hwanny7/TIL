function delay_word(delay) {
  return new Promise((resolve) => {
    setTimeout(function () {
      resolve(delay);
    }, delay);
  });
}

const array = [
  { delay: 500 },
  { delay: 490 },
  { delay: 480 },
  { delay: 470 },
  { delay: 460 },
];

array.reduce((prev, item) => {
  return prev.then(() =>
    delay_word(item.delay).then((promise) => {
      console.log(promise);
    })
  );
}, Promise.resolve());
