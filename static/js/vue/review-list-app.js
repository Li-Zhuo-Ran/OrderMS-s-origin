window.initReviewListApp = function () {
  const { createApp } = Vue;

  createApp({
    delimiters: ['[[', ']]'],
    data() {
      return {
        reviews: [],
        loading: true,
        reviewsUrl: window.__REVIEW_LIST_APP_DATA__.reviewsUrl,
      };
    },
    methods: {
      renderStars(rating) {
        return '★'.repeat(rating) + '☆'.repeat(5 - rating);
      },
      async loadReviews() {
        this.loading = true;
        try {
          const response = await fetch(this.reviewsUrl);
          const data = await response.json();
          this.reviews = data.reviews || [];
        } catch (error) {
          this.reviews = [];
        } finally {
          this.loading = false;
        }
      },
    },
    async mounted() {
      await this.loadReviews();
    },
  }).mount('#review-list-app');
};