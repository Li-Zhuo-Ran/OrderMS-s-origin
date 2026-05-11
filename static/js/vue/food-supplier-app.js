window.initFoodSupplierApp = function () {
    const { createApp } = Vue;

    createApp({
        data() {
            return {
                orders: [],
                statusMap: {
                    0: { text: '待接单', class: 'status-waiting' },
                    1: { text: '制作中', class: 'status-cooking' },
                    2: { text: '待上菜', class: 'status-ready' },
                    3: { text: '已上菜', class: 'status-delivered' }
                }
            };
        },
        mounted() {
            this.updateOrders();
            this.orderTimer = setInterval(() => this.updateOrders(), 8000);
            this.bindCardClickEvents();
        },
        beforeUnmount() {
            clearInterval(this.orderTimer);
        },
        methods: {
            updateOrders() {
                $.post('/manage/serving_order_item_list', data => {
                    try {
                        const orders = JSON.parse(data);
                        this.orders = orders;
                        this.renderOrderCards(orders);
                        this.bindCardClickEvents();
                    } catch (error) {
                        console.error('订单加载失败:', error);
                        $('#orders').html('<div style="text-align:center;padding:50px;color:#999;"><h3>数据加载失败</h3><p>错误信息：' + error.message + '</p></div>');
                    }
                }).fail((xhr, status, error) => {
                    console.error('请求失败:', error);
                    $('#orders').html('<div style="text-align:center;padding:50px;color:#999;"><h3>加载失败，请刷新页面</h3><p>错误：' + error + '</p></div>');
                });
            },
            renderOrderCards(orders) {
                const ordersContainer = $('#orders');
                ordersContainer.empty();

                if (!orders || orders.length === 0) {
                    ordersContainer.html('<div style="text-align:center;padding:50px;color:#999;"><h3>暂无订单</h3></div>');
                    return;
                }

                const groupedOrders = {};
                orders.forEach(order => {
                    const laneKey = '桌号' + order.table_id;
                    if (!groupedOrders[laneKey]) {
                        groupedOrders[laneKey] = [];
                    }
                    groupedOrders[laneKey].push(order);
                });

                Object.keys(groupedOrders).forEach(laneName => {
                    const laneOrders = groupedOrders[laneName];
                    const laneSection = $('<div class="lane-section"></div>');
                    const laneHeader = $('<div class="lane-header"><span class="lane-title">' + laneName + '(' + laneOrders.length + ')</span></div>');
                    const foodGrid = $('<div class="food-grid"></div>');

                    laneOrders.forEach(order => {
                        const combinedNum = order.table_id ? order.table_id + '+' + order.orderID_id : String(order.orderID_id);
                        const statusInfo = this.statusMap[order.status] || { text: '未知', class: 'status-unknown' };
                        const statusBg = order.status === 0 ? 'badge-danger' : (order.status === 1 ? 'badge-warning' : 'badge-info');
                        
                        const foodCard = $('<div class="food-card" data-order-id="' + order.orderID_id + '" data-food-id="' + order.foodID_id + '" data-status="' + order.status + '">' +
                            '<div class="food-card-header">' +
                            '<span class="food-order-num">' + combinedNum + '</span>' +
                            '<span class="badge ' + statusBg + '" style="margin-left:10px;">' + statusInfo.text + '</span>' +
                            '</div>' +
                            '<div class="food-card-body"><div class="food-name">' + order.food_name + '</div></div>' +
                            '<div class="food-card-footer">' +
                            '<span class="food-time">⏱ 0 分钟</span>' +
                            '<div class="food-quantity-wrapper">' +
                            '<span class="quantity-value">' + order.food_amount + '</span>' +
                            '<span class="quantity-unit">份</span>' +
                            '</div>' +
                            '</div>' +
                            '<div style="padding:10px;text-align:center;">' +
                            (order.status === 0 ? '<button class="btn btn-primary btn-sm accept-order-btn" style="width:100%;">接单</button>' :
                             order.status === 1 ? '<button class="btn btn-success btn-sm ready-order-btn" style="width:100%;">已准备好</button>' :
                             '<button class="btn btn-secondary btn-sm" style="width:100%;cursor:default;">已处理</button>') +
                            '</div>' +
                            '</div>');
                        foodGrid.append(foodCard);
                    });

                    laneSection.append(laneHeader);
                    laneSection.append(foodGrid);
                    ordersContainer.append(laneSection);
                });
            },
            bindCardClickEvents() {
                const self = this;
                
                // 接单按钮
                $('.accept-order-btn').off('click').on('click', function (e) {
                    e.stopPropagation();
                    const orderId = $(this).closest('.food-card').attr('data-order-id');
                    const foodId = $(this).closest('.food-card').attr('data-food-id');
                    self.acceptOrder(orderId, foodId, $(this));
                });

                // 已准备好按钮
                $('.ready-order-btn').off('click').on('click', function (e) {
                    e.stopPropagation();
                    const orderId = $(this).closest('.food-card').attr('data-order-id');
                    const foodId = $(this).closest('.food-card').attr('data-food-id');
                    self.readyOrder(orderId, foodId, $(this));
                });
            },
            acceptOrder(orderId, foodId, button) {
                const self = this;
                $.post('/cook', {
                    OP: 'take_order',
                    order_id: orderId,
                    food_id: foodId
                }, data => {
                    const response = JSON.parse(data);
                    if (response.status === 'OK') {
                        bs4pop.notice('已接单！', { type: 'success' });
                        self.updateOrders();
                    } else {
                        bs4pop.notice('接单失败！', { type: 'danger' });
                    }
                }).fail(error => {
                    bs4pop.notice('接单请求失败！', { type: 'danger' });
                    console.error('Error:', error);
                });
            },
            readyOrder(orderId, foodId, button) {
                const self = this;
                $.post('/cook', {
                    OP: 'ready_serve',
                    order_id: orderId,
                    food_id: foodId
                }, data => {
                    const response = JSON.parse(data);
                    if (response.status === 'OK') {
                        bs4pop.notice('已标记为可上菜！', { type: 'success' });
                        self.updateOrders();
                    } else {
                        bs4pop.notice('标记失败！', { type: 'danger' });
                    }
                }).fail(error => {
                    bs4pop.notice('标记请求失败！', { type: 'danger' });
                    console.error('Error:', error);
                });
            }
        },
    }).mount('#food-supplier-app');
};

document.addEventListener('DOMContentLoaded', () => {
    if (window.Vue && typeof window.initFoodSupplierApp === 'function') {
        window.initFoodSupplierApp();
    }
});
