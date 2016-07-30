document.addEventListener('DOMContentLoaded', function(){
  var slides = document.querySelectorAll('li');
  console.log(slides);
  var currentSlide = 0;
  var slideInterval = setInterval(nextSlide,3000);

  function nextSlide() {
    slides[currentSlide].className = 'hidden';
    currentSlide = (currentSlide+1)%slides.length;
    slides[currentSlide].className = 'showing';
  }
});