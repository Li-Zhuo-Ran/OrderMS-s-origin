window.initHomeApp = function () {
  const { createApp } = Vue;

  createApp({
    data() {
      return {
        currentSlide: 0,
        autoPlayInterval: null,
        slides: window.__HOME_APP_DATA__.slides,
        mainActions: window.__HOME_APP_DATA__.mainActions,
        secondaryActions: window.__HOME_APP_DATA__.secondaryActions,
      };
    },
    methods: {
      showSlide(index) {
        this.currentSlide = index;
      },
      nextSlide() {
        this.currentSlide = (this.currentSlide + 1) % this.slides.length;
      },
      prevSlide() {
        this.currentSlide = (this.currentSlide - 1 + this.slides.length) % this.slides.length;
      },
      goToSlide(index) {
        this.showSlide(index);
        this.resetAutoPlay();
      },
      startAutoPlay() {
        this.autoPlayInterval = window.setInterval(() => {
          this.nextSlide();
        }, 4000);
      },
      resetAutoPlay() {
        window.clearInterval(this.autoPlayInterval);
        this.startAutoPlay();
      },
    },
    mounted() {
      this.startAutoPlay();
      const carouselSection = this.$refs.carouselSection;
      carouselSection.addEventListener('mouseenter', () => {
        window.clearInterval(this.autoPlayInterval);
      });
      carouselSection.addEventListener('mouseleave', () => {
        this.startAutoPlay();
      });
    },
    beforeUnmount() {
      window.clearInterval(this.autoPlayInterval);
    },
  }).mount('#home-app');
};