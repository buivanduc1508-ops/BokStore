(function () {
  var menu = document.querySelector('[data-account-menu]');
  if (!menu) return;

  var trigger = menu.querySelector('.account-trigger');
  var dropdown = menu.querySelector('.account-dropdown');
  var avatarForm = menu.querySelector('.avatar-form');
  var avatarInput = menu.querySelector('.avatar-file-input');
  var avatarData = menu.querySelector('input[name="avatarData"]');
  var avatarChangeText = menu.querySelector('.avatar-change-text');
  var avatarStatus = menu.querySelector('.avatar-status');

  function setOpen(open) {
    trigger.setAttribute('aria-expanded', String(open));
    dropdown.hidden = !open;
  }

  trigger.addEventListener('click', function (event) {
    event.stopPropagation();
    setOpen(trigger.getAttribute('aria-expanded') !== 'true');
  });

  dropdown.addEventListener('click', function (event) {
    event.stopPropagation();
  });

  avatarChangeText.addEventListener('click', function () {
    avatarInput.click();
  });

  avatarInput.addEventListener('change', function () {
    var file = avatarInput.files && avatarInput.files[0];
    if (!file) return;
    if (!/^image\/(png|jpeg|webp)$/.test(file.type) || file.size > 5 * 1024 * 1024) {
      avatarStatus.textContent = 'Vui lòng chọn ảnh PNG, JPG hoặc WebP nhỏ hơn 5 MB.';
      avatarStatus.hidden = false;
      avatarInput.value = '';
      return;
    }

    avatarStatus.textContent = 'Đang xử lý ảnh...';
    avatarStatus.hidden = false;
    var reader = new FileReader();
    reader.onload = function () {
      var image = new Image();
      image.onload = function () {
        var size = Math.min(image.width, image.height);
        var canvas = document.createElement('canvas');
        canvas.width = 256;
        canvas.height = 256;
        var context = canvas.getContext('2d');
        context.drawImage(image, (image.width - size) / 2, (image.height - size) / 2, size, size, 0, 0, 256, 256);
        avatarData.value = canvas.toDataURL('image/jpeg', .84);
        avatarStatus.textContent = 'Đang lưu avatar...';
        avatarForm.submit();
      };
      image.onerror = function () {
        avatarStatus.textContent = 'Không thể đọc tệp ảnh này.';
      };
      image.src = reader.result;
    };
    reader.readAsDataURL(file);
  });

  document.addEventListener('click', function () {
    setOpen(false);
  });

  document.addEventListener('keydown', function (event) {
    if (event.key === 'Escape') {
      setOpen(false);
      trigger.focus();
    }
  });
})();
