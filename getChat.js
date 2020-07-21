var lastSender = null;
let observer = new MutationObserver(mutations => {
  mutations.forEach(mutation=>{
    const added = mutation.addedNodes[0];
    window.console.log(added);
    if(added.classList.value === "GDhqjd"){
      const name = added.dataset.senderName;
      lastSender = name;
      const message = added.querySelector(".oIy2qc").dataset.messageText;
      window.console.log(name);
      window.console.log(message);
    }else if(added.classList.value === "oIy2qc"){
      const message = added.dataset.messageText;
      window.console.log(lastSender);
      window.console.log(message);
    }
  })
});

observer.observe(document.getElementsByClassName('z38b6')[0], {
  childList: true,
  characterData: true,
  subtree: true
});
