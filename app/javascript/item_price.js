const priceCalculation = () => {
  const priceInput = document.getElementById("item-price");
  priceInput.addEventListener("input", () => {
    const priceValue = priceInput.value;
    const addTaxPrice = document.getElementById("add-tax-price");
    const profit = document.getElementById("profit");

    if (priceValue >= 300 && priceValue <= 9999999) {
      // 販売手数料（10%）を計算し、小数点以下を切り捨てる
      const tax = Math.floor(priceValue * 0.1);
      // 販売利益を計算
      const itemProfit = priceValue - tax;

      addTaxPrice.textContent = tax;
      profit.textContent = itemProfit;
    } else {
      // 価格が範囲外の場合は表示をクリア
      addTaxPrice.textContent = '';
      profit.textContent = '';
    }
  });
};

window.addEventListener('turbo:load', priceCalculation);