(function () {
  var modal = document.getElementById('adminConfirm');
  if (!modal) return;

  var dialog = modal.querySelector('.admin-confirm-dialog');
  var title = modal.querySelector('#confirmTitle');
  var message = modal.querySelector('#confirmMessage');
  var accept = modal.querySelector('[data-confirm-accept]');
  var cancelButtons = modal.querySelectorAll('[data-confirm-cancel]');
  var pendingForm = null;
  var pendingSubmitter = null;

  function cleanText(value) {
    return (value || '').replace(/\s+/g, ' ').trim();
  }

  function describe(form, submitter) {
    var action = cleanText(submitter && submitter.textContent) || 'Lưu thay đổi';
    var row = form.closest('tr');
    var target = '';
    if (row) {
      var strong = row.querySelector('strong');
      var namedInput = row.querySelector('input[name="name"]');
      target = cleanText(strong && strong.textContent) || cleanText(namedInput && namedInput.value);
    }
    if (!target) {
      var formName = form.querySelector('input[name="name"]');
      target = cleanText(formName && formName.value);
    }
    var destructive = !!(submitter && submitter.classList.contains('danger')) || /xóa|ẩn|khóa|hủy/i.test(action);
    return { action: action, target: target, destructive: destructive };
  }

  function closeModal() {
    modal.hidden = true;
    document.body.style.overflow = '';
    if (pendingSubmitter) pendingSubmitter.focus();
    pendingForm = null;
    pendingSubmitter = null;
  }

  document.addEventListener('submit', function (event) {
    var form = event.target;
    if (!(form instanceof HTMLFormElement) || form.method.toLowerCase() !== 'post') return;
    if (form.dataset.confirmed === 'true') {
      delete form.dataset.confirmed;
      return;
    }

    event.preventDefault();
    pendingForm = form;
    pendingSubmitter = event.submitter || form.querySelector('button[type="submit"],button:not([type])');
    var details = describe(form, pendingSubmitter);
    title.textContent = 'Xác nhận ' + details.action.toLowerCase() + '?';
    message.innerHTML = 'Bạn có chắc chắn muốn thực hiện thao tác này không?' +
      (details.target ? '<span class="admin-confirm-target"></span>' : '');
    if (details.target) message.querySelector('.admin-confirm-target').textContent = details.target;
    dialog.classList.toggle('is-danger', details.destructive);
    accept.textContent = details.destructive ? 'Có, ' + details.action.toLowerCase() : 'Xác nhận';
    modal.hidden = false;
    document.body.style.overflow = 'hidden';
    accept.focus();
  });

  accept.addEventListener('click', function () {
    if (!pendingForm) return;
    var form = pendingForm;
    var submitter = pendingSubmitter;
    modal.hidden = true;
    document.body.style.overflow = '';
    form.dataset.confirmed = 'true';
    form.requestSubmit(submitter || undefined);
  });

  cancelButtons.forEach(function (button) {
    button.addEventListener('click', closeModal);
  });

  document.addEventListener('keydown', function (event) {
    if (event.key === 'Escape' && !modal.hidden) closeModal();
  });
})();
