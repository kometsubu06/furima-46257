let payFunctionExecuted = false;
const pay = () => {
  const form = document.getElementById("charge-form");
  if (!form) { return; }

  payFunctionExecuted = true;

  const dependenciesReady = new Promise((resolve) => {
    const interval = setInterval(() => {
      // gonと公開鍵が確実に存在することを確認
      if (typeof window.gon !== 'undefined' && gon.public_key) {
        clearInterval(interval);
        resolve();
      }  
    }, 50);
  });
  
  dependenciesReady.then(() => {
    try {
      const payjp = Payjp(gon.public_key);
      const elements = payjp.elements();
      const numberElement = elements.create('cardNumber');
      const expiryElement = elements.create('cardExpiry');
      const cvcElement = elements.create('cardCvc');
      
      numberElement.mount('#number-form');
      expiryElement.mount('#expiry-form');
      cvcElement.mount('#cvc-form');
      form.addEventListener("submit", (e) => {
        e.preventDefault();
        
        const submitBtn = document.getElementById("button");
        if (submitBtn) {
          submitBtn.disabled = true;
          submitBtn.value = "処理中...";
        }

        payjp.createToken(numberElement).then(function(response) {
          if (response.error) {
            
          } else {
            const token = response.id;
            const renderDom = document.getElementById("charge-form");
            const tokenObj = `<input value=${token} name='order_form[token]' type="hidden">`;
            renderDom.insertAdjacentHTML("beforeend", tokenObj);
            // トークンが正常に取得できた場合のみフォームを送信する
          }
          e.target.submit();
        }).catch((e) => {
          
          if (submitBtn) {
            submitBtn.disabled = false;
            submitBtn.value = "購入";
          }
        });
      });
    } catch (e) {
      console.error("PAY.JPの初期化に失敗しました:", e);
    }
  });
};

window.addEventListener("turbo:load", pay);
window.addEventListener("turbo:render", pay);
