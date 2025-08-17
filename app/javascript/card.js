console.log("gon.public_key:", gon.public_key);
const pay = () => {
  const form = document.getElementById('charge-form');
  if (!form) {
    return;
  }

  const publicKey = gon.public_key
  const payjp = Payjp(publicKey)
  const elements = payjp.elements();
  const numberElement = elements.create('cardNumber');
  const expiryElement = elements.create('cardExpiry');
  const cvcElement = elements.create('cardCvc');
  
  numberElement.mount('#number-form');
  expiryElement.mount('#expiry-form');
  cvcElement.mount('#cvc-form');
  
  form.addEventListener("submit", (e) => {
    e.preventDefault();
    payjp.createToken(numberElement, {
      card: {
        number: numberElement,
        exp_month: expiryElement,
        exp_year: expiryElement,
        cvc: cvcElement,
      }
    }).then((response) => {
      if (response.error) {
        alert(response.error.message);
      } else {
        const token = response.id;
        const tokenInput = document.getElementById('token');
        tokenInput.value = token;
        form.submit();
      }
    });
  });
};

window.addEventListener("turbo:load", pay)
