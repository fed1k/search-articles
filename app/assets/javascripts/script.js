document.addEventListener("DOMContentLoaded", function () {
  const searchInput = document.getElementById("search");
  // searchInput.addEventListener("focus", function () {
  //   searchInput.style.boxShadow = "0 0 3px 0 #d3d3d3";
  // })
  // searchInput.addEventListener("blur", function () {
  //   searchInput.style.boxShadow = "0 0 0 0";
  // })
  let arr = [];
  const articlesContainer = document.getElementById("articles");
  searchInput.addEventListener("input", function () {
    var inputValue = searchInput.value;
    if (!inputValue) articlesContainer.innerHTML = "";
    if (inputValue) handleSearch(inputValue);
    debouncedFunction(inputValue, arr);
  });

  var csrfToken = document.querySelector('meta[name="csrf-token"]').content;
  async function ajaxCall(val) {
    fetch("/save_log", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": csrfToken,
      },
      body: JSON.stringify({ searchQuery: val }),
    })
      .then((response) => {
        if (!response.ok) throw new Error("Network response was not ok");
        return response.json();
      })
      .then((responseData) => {
        console.log("Controller action response:", responseData);
      })
      .catch((error) => {
        console.error("Error calling controller action:", error);
      });
  }
  function debounce(func, delay) {
    let timeoutId;
    return function (...args) {
      clearTimeout(timeoutId);
      timeoutId = setTimeout(() => func.apply(this, args), delay);
    };
  }
  // DELAYED LOGIC
  const debouncedFunction = debounce((text, arr) => {
    if (text && !text.endsWith(" ")) arr.push(text);
    if (arr.length > 1 && arr.at(-1).startsWith(arr[0])) arr.shift();
    if (!isCompleteString(arr.at(-1))) ajaxCall(arr.at(-1));
  }, 2000);

  function isCompleteString(str) {
    const endings = [" a", " an", " the", " is", " and", " but", " or", " so"];
    return endings.some((ending) => str.endsWith(ending));
  }

  async function handleSearch(query) {
    // Make an AJAX request to the Rails backend
    fetch(`/search`, {
      method: "POST",
      body: JSON.stringify({ query }),
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": csrfToken,
      },
    })
      .then((response) => response.json())
      .then((data) => {
        const articlesContainer = document.getElementById("articles");
        if (!data.length) {
          articlesContainer.innerHTML = "";
          return;
        }
        articlesContainer.innerHTML = "";
        data.forEach((el) => {
          if (articlesContainer.innerHTML.includes(el.article_name)) return;
          const article = document.createElement("p");
          article.textContent = el.article_name;
          articlesContainer.appendChild(article);
        });
      })
      .catch((error) => console.error("Error:", error));
  }
});
