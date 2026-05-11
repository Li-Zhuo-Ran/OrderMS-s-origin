window.initManageApp = function () {
    const { createApp } = Vue;

    createApp({
        mounted() {
            this.bindTableRowClick();
            this.bindStaffButtons();
            this.bindDeliverButtons();
            this.bindSearchInput();
            this.updateTableStatus();
            this.updateOrderItemInfo();
            this.tableTimer = setInterval(() => this.updateTableStatus(), 30000);
            this.orderTimer = setInterval(() => this.updateOrderItemInfo(), 10000);
        },
        beforeUnmount() {
            clearInterval(this.tableTimer);
            clearInterval(this.orderTimer);
        },
        methods: {
            getCsrfToken() {
                const tokenInput = document.querySelector('input[name="csrfmiddlewaretoken"]');
                return tokenInput ? tokenInput.value : '';
            },
            bindSearchInput() {
                $('.manage-search-input').off('keypress').on('keypress', function (event) {
                    if (event.which !== 13) {
                        return;
                    }
                    const searchText = $(this).val();
                    if (!searchText) {
                        return;
                    }
                    $('#table-info-table tr[table_id]').each(function () {
                        const tableText = $(this).text();
                        if (tableText.includes(searchText)) {
                            $(this).show();
                        } else {
                            $(this).hide();
                        }
                    });
                });
            },
            bindTableRowClick() {
                $('#table-info-table tr[table_id]')
                    .off('click')
                    .on('click', function () {
                        const tableId = $(this).attr('table_id');
                        $('#table-info-table tr[table_id!=' + tableId + ']').each(function () {
                            $(this).removeClass('active');
                        });
                    });
            },
            updateTableStatus() {
                $.post('/manage/serving_table_list', data => {
                    $('#table-info-table tr[table_id]').each(function () {
                        $(this).removeClass('serving');
                        $(this).find('td:last').html('');
                    });

                    const response = JSON.parse(data);
                    const servingTableList = response.servingTableList || [];
                    servingTableList.forEach(tableId => {
                        const table = $('#table-info-table tr[table_id=' + tableId + ']');
                        if (!table.hasClass('serving')) {
                            table.addClass('serving');
                            table.find('td:last').html('');
                        }
                    });

                    bs4pop.notice('已刷新餐桌负责状态表！', { position: 'bottomright' });
                });
            },
            updateOrderItemInfo() {
                $('.table-detail').each(function () {
                    $(this).find('.order-item-table').empty();
                });

                $.post('/manage/serving_order_item_list', data => {
                    const itemList = JSON.parse(data);
                    itemList.forEach(food => {
                        const rowHtml =
                            '<div class="row food-item" status="' +
                            food.status +
                            '" order_id="' +
                            food.orderID_id +
                            '" food_id="' +
                            food.foodID_id +
                            '">\
                                <div class="col">' +
                            food.orderID_id +
                            '</div>\
                                <div class="col">' +
                            food.food_name +
                            '</div>\
                                <div class="col">' +
                            food.food_amount +
                            '</div>\
                                <div class="col-3">' +
                            this.getFoodStatusText(food.status) +
                            '</div>\
                                <div class="col-2 p-0"><button class="btn delive-food-btn btn-block btn-danger disabled">上菜</button></div>\
                            </div>';
                        $('#table-' + food.table_id + '-content .order-item-table').append(rowHtml);
                    });

                    this.updateFoodServeStatus();
                    bs4pop.notice('已刷新上菜信息！', { position: 'bottomright' });
                });
            },
            updateFoodServeStatus() {
                $('.table-detail').each(function () {
                    const tableId = $(this).attr('table_id');
                    let waiting = false;
                    $(this)
                        .find('.food-item')
                        .each(function () {
                            const status = parseInt($(this).attr('status'));
                            if (status === 2) {
                                $(this).addClass('waiting');
                                waiting = true;
                                $(this).find('button').removeClass('disabled');
                            } else {
                                $(this).removeClass('waiting');
                                $(this).find('button').addClass('disabled');
                            }
                        });
                    if (waiting) {
                        $('#table-' + tableId).addClass('waiting');
                        $('#table-' + tableId + ' td:last').html('等待上菜');
                    } else {
                        $('#table-' + tableId).removeClass('waiting');
                        $('#table-' + tableId + ' td:last').html('');
                    }
                });
                this.bindDeliverButtons();
            },
            bindStaffButtons() {
                $('.staff-opt-btn')
                    .off('click')
                    .on('click', function () {
                        const tableId = $(this).parents('.table-detail').attr('table_id');
                        const staffId = $(this).attr('staff_id');
                        const staffName = $(this).html();
                        const currentStaffName = $('#staff-name-in-table-' + tableId).html();
                        if (currentStaffName === staffName) {
                            bs4pop.notice('无效！');
                            return;
                        }

                        $.post('/manage/staff_charge_table', {
                            table_id: tableId,
                            staff_id: staffId,
                        }, function (data) {
                            const response = JSON.parse(data);
                            if (response.status === 'OK') {
                                bs4pop.notice('成功修改餐桌负责人！');
                                $('#staff-name-in-table-' + tableId).html(staffName);
                            } else {
                                bs4pop.notice('操作失败！');
                            }
                        });
                    });
            },
            bindDeliverButtons() {
                $('.delive-food-btn')
                    .off('click')
                    .on('click', function () {
                        if ($(this).hasClass('disabled')) {
                            bs4pop.notice('已上过此菜！');
                            return;
                        }

                        const foodItem = $(this).parents('.food-item');
                        const orderId = foodItem.attr('order_id');
                        const foodId = foodItem.attr('food_id');
                        $.post('/manage/delive_food', {
                            order_id: orderId,
                            food_id: foodId,
                        }, function (data) {
                            const response = JSON.parse(data);
                            if (response.status === 'OK') {
                                bs4pop.notice('上菜成功！');
                            } else {
                                bs4pop.notice('操作失败！');
                            }
                        });
                    });
            },
            getFoodStatusText(status) {
                const statusText = ['等待后厨接单', '后厨已接单', '等待上菜', '上菜完成'];
                return statusText[status] || '';
            },
        },
    }).mount('#manage-app');
};

document.addEventListener('DOMContentLoaded', () => {
    if (window.Vue && typeof window.initManageApp === 'function') {
        window.initManageApp();
    }
});
