function uploadImageToServer($croppedModalImage, $form) {
  var canvas = $croppedModalImage.cropper('getCroppedCanvas');
  canvas.toBlob(function (blob) {
    var formData = new FormData();
    formData.append('avatar', blob, 'blob.png');
    $.ajax($form.data('avatar-path'), {
      method: 'POST',
      data: formData,
      processData: false,
      contentType: false,
      xhr: function () {  // Custom XMLHttpRequest
        var myXhr = $.ajaxSettings.xhr();
        if (myXhr.upload) { // Check if upload property exists
          myXhr.upload.addEventListener('progress', function progressHandlingFunction() {
          }, false); // For handling the progress of the upload
        }
        return myXhr;
      },
      success: function () {
        $('#image').replaceWith($('<div>', {'id': 'image'}).html(canvas));
      },
      error: function () {
        console.log('Upload error');
      }
    });
  });
}

var editEventManager = {
  bindDeleteAvatarButton: function($imageForm, $image, $deleteBtn) {
    $deleteBtn.on('click', function () {
      deleteAvatar($imageForm);
      $image.attr('src', $image.data('default-avatar-path'));
      return false;
    });
  },

  initCropper: function($croppedModalImage, $imageInput, $modal, $uploadImage, $imageForm, $currentImage) {
    imageImport.bind($croppedModalImage, $imageInput, $modal);
    cropper.create($croppedModalImage, $currentImage, $imageForm, function onCropperCreated() {
      $uploadImage.on('click', function () {
        uploadImageToServer($croppedModalImage, $imageForm);
      });
    });
  }
};
