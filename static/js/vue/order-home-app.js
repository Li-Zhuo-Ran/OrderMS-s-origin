window.initOrderHomeApp = function () {
    const { createApp } = Vue;

    createApp({
        data() {
            return {
                currentTable: 0,
                orderList: [],
                totalPrice: 0,
            };
        },
        mounted() {
            window.addToOrder = this.addToOrder.bind(this);
            window.updateAmount = this.updateAmount.bind(this);
            window.toggleOrderSidebar = this.toggleOrderSidebar.bind(this);
            window.selectTable = this.selectTable.bind(this);
            window.submitOrder = this.submitOrder.bind(this);
            this.bindCategorySwitch();
            this.bindSearchInput();
            this.updateOrderDisplay();
            this.updateCartCount();
        },
        methods: {
            bindCategorySwitch() {
                $('.category-item').off('click').on('click', function () {
                    $('.category-item').removeClass('active');
                    $(this).addClass('active');

                    const target = $(this).data('target');
                    $('.food-section').hide();
                    if (target === 'all') {
                        $('#section-all').show();
                    } else {
                        $('#section-' + target).show();
                    }
                });
            },
            bindSearchInput() {
                $('.search-input').off('keypress').on('keypress', event => {
                    if (event.which !== 13) {
                        return;
                    }
                    const searchText = $(event.currentTarget).val();
                    if (!searchText) {
                        return;
                    }
                    $('.food-item').each(function () {
                        const title = $(this).find('.food-title').text();
                        if (title.includes(searchText)) {
                            $(this).show();
                        } else {
                            $(this).hide();
                        }
                    });
                });
            },
            addToOrder(foodId, foodTitle, foodPrice) {
                const existingItem = this.orderList.find(item => item.id === foodId);
                if (existingItem) {
                    existingItem.amount += 1;
                } else {
                    this.orderList.push({
                        id: foodId,
                        title: foodTitle,
                        price: foodPrice,
                        amount: 1,
                    });
                }
                this.updateOrderDisplay();
                this.updateCartCount();
            },
            updateAmount(foodId, change) {
                const item = this.orderList.find(entry => entry.id === foodId);
                if (!item) {
                    return;
                }
                item.amount += change;
                if (item.amount <= 0) {
                    this.orderList = this.orderList.filter(entry => entry.id !== foodId);
                }
                this.updateOrderDisplay();
                this.updateCartCount();
            },
            updateOrderDisplay() {
                const orderListEl = $('#OrderList');
                orderListEl.empty();
                this.totalPrice = 0;

                this.orderList.forEach(item => {
                    const itemTotal = item.price * item.amount;
                    this.totalPrice += itemTotal;
                    const orderItemHtml = '<div class="order-item">' +
                        '<div><strong>' + item.title + '</strong><div>￥' + item.price + ' × ' + item.amount + '</div></div>' +
                        '<div>' +
                        '<button class="btn btn-sm btn-outline-secondary" onclick="updateAmount(' + item.id + ', -1)">-</button>' +
                        '<span class="mx-2">' + item.amount + '</span>' +
                        '<button class="btn btn-sm btn-outline-secondary" onclick="updateAmount(' + item.id + ', 1)">+</button>' +
                        '</div>' +
                        '</div>';
                    orderListEl.append(orderItemHtml);
                });

                $('#orderPrice').text('￥ ' + this.totalPrice.toFixed(2));
            },
            updateCartCount() {
                const count = this.orderList.reduce((sum, item) => sum + item.amount, 0);
                $('#cartCount').text(count);
            },
            toggleOrderSidebar() {
                $('#orderSidebar').toggleClass('show');
            },
            selectTable(tableId) {
                this.currentTable = tableId;
                $('.room-opt-btn').removeClass('active');
                $('.room-opt-btn').filter(function () {
                    return $(this).text().trim() === String(tableId);
                }).addClass('active');
            },
            submitOrder() {
                if (this.orderList.length === 0) {
                    bs4pop.notice('请选择菜品！', { type: 'danger' });
                    return;
                }

                if (this.currentTable === 0) {
                    bs4pop.notice('请选择桌号！', { type: 'danger' });
                    return;
                }

                for (let index = 0; index < this.orderList.length; index += 1) {
                    const orderItem = this.orderList[index];
                    const foodItem = $('.food-item[foodID="' + orderItem.id + '"]');
                    const stockAmount = parseInt(foodItem.find('.food-stock-value').text(), 10);
                    if (stockAmount < orderItem.amount) {
                        bs4pop.notice(orderItem.title + ' 库存不足！', { type: 'danger' });
                        return;
                    }
                }

                bs4pop.confirm('请确认桌号为 ' + this.currentTable + '，总价为 ￥' + this.totalPrice.toFixed(2) + '！', sure => {
                    if (!sure) {
                        return;
                    }

                    $.ajax({
                        url: '/order',
                        type: 'POST',
                        data: {
                            foodList: JSON.stringify(this.orderList),
                            table: this.currentTable,
                        },
                        success: response => {
                            try {
                                const data = JSON.parse(response);
                                const orderId = data.order_id;
                                bs4pop.success('订单提交成功！', { type: 'success' });
                                this.orderList = [];
                                this.totalPrice = 0;
                                this.updateOrderDisplay();
                                this.updateCartCount();
                                this.toggleOrderSidebar();
                                setTimeout(() => {
                                    window.location.href = '/order/q' + orderId;
                                }, 1000);
                            } catch (error) {
                                bs4pop.notice('订单提交失败：' + error.message, { type: 'danger' });
                            }
                        },
                        error: (xhr, status, error) => {
                            console.error('提交失败:', status, error);
                            bs4pop.notice('订单提交失败，请重试！错误信息：' + error, { type: 'danger' });
                        },
                    });
                }, { title: '确认订单' });
            },
        },
    }).mount('#order-home-app');
};

document.addEventListener('DOMContentLoaded', () => {
    if (window.Vue && typeof window.initOrderHomeApp === 'function') {
        window.initOrderHomeApp();
    }
});
