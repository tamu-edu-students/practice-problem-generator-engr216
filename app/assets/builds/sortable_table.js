document.addEventListener('DOMContentLoaded', () => {
    const table = document.querySelector('.sortable');
    if (!table) return;
  
    const ths   = Array.from(table.querySelectorAll('th'));
    const tbody = table.querySelector('tbody');
  
    ths.forEach((th, col) => {
      if (th.classList.contains('no-sort')) return;
      th.style.cursor = 'pointer';
      let asc = true;
  
      th.addEventListener('click', () => {
        const rows = Array.from(tbody.querySelectorAll('tr'));
        rows.sort((a, b) => {
          const aText = a.children[col].innerText.trim();
          const bText = b.children[col].innerText.trim();
          const aNum  = parseFloat(aText);
          const bNum  = parseFloat(bText);
  
          if (!isNaN(aNum) && !isNaN(bNum)) {
            return asc ? aNum - bNum : bNum - aNum;
          }
          return asc
            ? aText.localeCompare(bText)
            : bText.localeCompare(aText);
        });
        rows.forEach(r => tbody.appendChild(r));
        asc = !asc;
        ths.forEach(h => h.classList.remove('asc','desc'));
        th.classList.add(asc ? 'asc' : 'desc');
      });
    });
  });
  