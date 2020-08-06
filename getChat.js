{
  let lastSender = null;
  const sendMessage = async (sender, text) => {
    const room_key = window.location.href.split("/").slice(-1)[0];
    const res = await fetch(`http://127.0.0.1:3000/rooms/${room_key}/messages`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify({message:{sender: sender, text: text}})
    });
    window.console.debug(res.json());
  }

  let observer = new MutationObserver(mutations => {
    mutations.forEach(async mutation => {
      const added = mutation.addedNodes[0];
      // window.console.log(added);
      if (added.classList.value === "GDhqjd") {
        const name = added.dataset.senderName;
        lastSender = name;
        const message = added.querySelector(".oIy2qc").dataset.messageText;
        await sendMessage(name, message);
      } else if (added.classList.value === "oIy2qc") {
        const message = added.dataset.messageText;
        await sendMessage(lastSender, message);
      }
    })
  });

  observer.observe(document.getElementsByClassName("z38b6")[0], {
    childList: true,
    characterData: true,
    subtree: true
  });
}