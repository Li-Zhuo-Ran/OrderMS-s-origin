window.initReviewApp = function () {
  const { createApp } = Vue;

  createApp({
    delimiters: ['[[', ']]'],
    data() {
      return {
        ratingOptions: [5, 4, 3, 2, 1],
        form: {
          name: '',
          rating: 5,
          comment: '',
        },
        reviews: [],
        submitting: false,
        message: '',
        messageType: 'text-success',
        submitUrl: window.__REVIEW_APP_DATA__.submitUrl,
        reviewsUrl: window.__REVIEW_APP_DATA__.reviewsUrl,
        csrfToken: window.__REVIEW_APP_DATA__.csrfToken,
      };
    },
    computed: {
      messageClass() {
        return this.messageType;
      },
    },
    methods: {
      async loadReviews() {
        const response = await fetch(this.reviewsUrl);
        const data = await response.json();
        this.reviews = data.reviews || [];
      },
      renderStars(rating) {
        const filled = '★'.repeat(rating);
        const empty = '☆'.repeat(5 - rating);
        return `<span class="text-warning">${filled}</span><span class="text-muted">${empty}</span>`;
      },
      async submitReview() {
        if (!this.form.rating || !this.form.comment) {
          this.message = '请先填写评分和评价内容';
          this.messageType = 'text-danger';
          return;
        }

        this.submitting = true;
        this.message = '';

        const formData = new FormData();
        formData.append('name', this.form.name);
        formData.append('rating', this.form.rating);
        formData.append('comment', this.form.comment);
        formData.append('csrfmiddlewaretoken', this.csrfToken);

        const response = await fetch(this.submitUrl, {
          method: 'POST',
          body: formData,
          headers: {
            'X-Requested-With': 'XMLHttpRequest',
          },
        });

        this.submitting = false;

        if (response.redirected || response.ok) {
          this.form.name = '';
          this.form.rating = 5;
          this.form.comment = '';
          this.message = '评价提交成功！感谢您的反馈。';
          this.messageType = 'text-success';
          await this.loadReviews();
          return;
        }

        this.message = '提交失败，请稍后重试';
        this.messageType = 'text-danger';
      },
    },
    async mounted() {
      await this.loadReviews();
    },
  }).mount('#review-app');
};