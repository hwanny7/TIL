const barbecue = new Promise(function (resolve, reject) {
  setTimeout(function () {
    resolve("바베큐");
  }, 10000);
});

async function order() {
  console.log("바베큐 불에 올려 놓는다!");
  const food = await barbecue;
  console.log(food);
}

order();
console.log("라면");
