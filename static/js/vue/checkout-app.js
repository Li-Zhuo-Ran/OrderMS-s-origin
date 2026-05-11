window.initCheckoutApp = function () {
    const { createApp } = Vue;

    createApp({
        data() {
            return {
                selectedOrderIds: [],
            };
        },
        mounted() {
            this.bindOrderBoxes();
            this.bindSubmitButton();
            this.updatePrice();
            if ($('.list-group').children().length === 0) {
                $('.list-group').append('<h3>暂无新订单</h3>');
            }
        },
        methods: {
            bindOrderBoxes() {
                $('.order-check-box')
                    .off('click')
                    .on('click', event => {
                        const box = $(event.currentTarget);
                        const order = box.next();
                        const orderId = String(order.attr('order_id'));

                        if (box.hasClass('check')) {
                            box.removeClass('check');
                            order.removeClass('check-order-green');
                            this.selectedOrderIds = this.selectedOrderIds.filter(id => String(id) !== orderId);
                        } else {
                            box.addClass('check');
                            order.addClass('check-order-green');
                            if (!this.selectedOrderIds.includes(orderId)) {
                                this.selectedOrderIds.push(orderId);
                            }
                        }
                        this.updatePrice();
                    });
            },
            updatePrice() {
                let totalPrice = 0;
                this.selectedOrderIds.forEach(orderId => {
                    const orderPrice = parseFloat($('.order[order_id=' + orderId + ']').attr('order_price')) || 0;
                    totalPrice += orderPrice;
                });
                $('#total_price').html(totalPrice.toFixed(2));
                if (totalPrice === 0) {
                    $('#OrderSubmit').addClass('disabled');
                } else {
                    $('#OrderSubmit').removeClass('disabled');
                }
            },
            bindSubmitButton() {
                $('#OrderSubmit')
                    .off('click')
                    .on('click', () => {
                        if (this.selectedOrderIds.length === 0) {
                            bs4pop.notice('请点击需要批量支付的订单前面的方框！', { type: 'warning' });
                            return;
                        }

                        bs4pop.confirm('确认批量支付!', sure => {
                            if (!sure) {
                                return;
                            }
                            this.submitCheckout();
                        }, { title: '' });
                    });
            },
            submitCheckout() {
                bs4pop.notice('正在批量支付订单！', { type: 'info' });
                const orderDataList = this.selectedOrderIds.map(orderId => ({
                    order_id: orderId,
                    is_pay: true,
                }));

                $.post('/order/checkout', {
                    order_list: JSON.stringify(orderDataList),
                }, data => {
                    const response = JSON.parse(data);
                    if (response.status === 'OK') {
                        bs4pop.notice('支付成功！即将返回主页.');
                        setTimeout(() => {
                            window.location.href = '/manage/';
                        }, 2000);
                    } else if (response.status === 'NO_PAY') {
                        bs4pop.notice('支付失败！');
                    } else if (response.status === 'ALREADY_PAY') {
                        bs4pop.notice('支付失败，可能是部分订单已经支付！请刷新页面！');
                    }
                });
            },
        },
    }).mount('#checkout-app');
};

document.addEventListener('DOMContentLoaded', () => {
    if (window.Vue && typeof window.initCheckoutApp === 'function') {
        window.initCheckoutApp();
    }
});
