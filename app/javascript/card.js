const pay = () => {
  const publicKey = gon.public_key
  const payjp = Payjp(publicKey)
  const elements = payjp.elements();
  const numberElement = elements.create('cardNumber');
  const expiryElement = elements.create('cardExpiry');
  const cvcElement = elements.create('cardCvc');

  numberElement.mount('#number-form');
  expiryElement.mount('#expiry-form');
  cvcElement.mount('#cvc-form');

  const form = document.getElementById('charge-form')
  form.addEventListener("submit", (e) => {
    e.preventDefault(); // 先頭に移動
    payjp.createToken(numberElement).then((response) => {
      if (response.error) {
        // エラーハンドリング
        console.error(response.error);
        alert(response.error.message);
      } else {
        const token = response.id;
        const tokenInput = document.getElementById('token');
        tokenInput.value = token;
        form.submit(); // submitをthenブロック内に移動
      }
    });
  });
};

window.addEventListener("turbo:load", pay);
window.addEventListener("turbo:render", pay);