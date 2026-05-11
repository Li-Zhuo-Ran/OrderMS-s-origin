window.initFoodSupplierApp = function () {
    const { createApp } = Vue;

    createApp({
        data() {
            return {
                orders: [],
                loading: false,
                errorMessage: "",
                statusMap: {
                    0: { text: "待接单", class: "badge-danger" },
                    1: { text: "已接单", class: "badge-warning" },
                    2: { text: "制作中", class: "badge-primary" },
                    3: { text: "待上菜", class: "badge-info" },
                    4: { text: "已上菜", class: "badge-success" },
                    5: { text: "已取消", class: "badge-secondary" },
                },
            };
        },
        computed: {
            groupedOrders() {
                const grouped = {};
                this.orders.forEach((order) => {
                    const tableLabel = `桌号 ${order.table_id}`;
                    if (!grouped[tableLabel]) {
                        grouped[tableLabel] = [];
                    }
                    grouped[tableLabel].push(order);
                });
                return grouped;
            },
        },
        mounted() {
            this.updateOrders();
            this.orderTimer = setInterval(() => this.updateOrders(), 8000);
        },
        beforeUnmount() {
            clearInterval(this.orderTimer);
        },
        methods: {
            getCookie(name) {
                let cookieValue = null;
                if (document.cookie && document.cookie !== "") {
                    const cookies = document.cookie.split(";");
                    for (let i = 0; i < cookies.length; i += 1) {
                        const cookie = cookies[i].trim();
                        if (cookie.substring(0, name.length + 1) === `${name}=`) {
                            cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
                            break;
                        }
                    }
                }
                return cookieValue;
            },
            getStatusMeta(status) {
                return this.statusMap[status] || { text: "未知", class: "status-unknown" };
            },
            getAction(order) {
                const actions = {
                    0: { label: "接单", endpoint: "/cook", payload: { action: "accept_order" } },
                    1: { label: "开始制作", endpoint: "/cook", payload: { action: "start_cooking" } },
                    2: { label: "制作完成", endpoint: "/cook", payload: { action: "mark_ready" } },
                    3: { label: "上菜", endpoint: "/delive_food", payload: {} },
                };
                return actions[order.status] || null;
            },
            async updateOrders() {
                this.loading = true;
                this.errorMessage = "";
                const token = this.getCookie("csrftoken");
                try {
                    const response = await fetch("/manage/serving_order_item_list", {
                        method: "POST",
                        headers: {
                            "X-CSRFToken": token,
                            "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8",
                        },
                        body: "",
                    });
                    if (!response.ok) {
                        throw new Error("订单查询失败");
                    }
                    this.orders = await response.json();
                } catch (error) {
                    this.errorMessage = error.message || "加载失败";
                    this.orders = [];
                } finally {
                    this.loading = false;
                }
            },
            async updateOrderStatus(order, action) {
                const token = this.getCookie("csrftoken");
                const payload = new URLSearchParams({
                    order_id: String(order.orderID_id),
                    food_id: String(order.foodID_id),
                    ...action.payload,
                });
                const response = await fetch(action.endpoint, {
                    method: "POST",
                    headers: {
                        "X-CSRFToken": token,
                        "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8",
                    },
                    body: payload,
                });

                const data = await response.json();
                if (!response.ok || data.status !== "OK") {
                    throw new Error(data.message || "状态更新失败");
                }
                await this.updateOrders();
            },
            async runAction(order) {
                const action = this.getAction(order);
                if (!action) {
                    return;
                }
                try {
                    await this.updateOrderStatus(order, action);
                    if (window.bs4pop) {
                        bs4pop.notice(`操作成功：${action.label}`, { type: "success" });
                    }
                } catch (error) {
                    if (window.bs4pop) {
                        bs4pop.notice(error.message || "操作失败", { type: "danger" });
                    }
                }
            },
        },
    }).mount("#food-supplier-app");
};

document.addEventListener("DOMContentLoaded", () => {
    if (window.Vue && typeof window.initFoodSupplierApp === "function") {
        window.initFoodSupplierApp();
    }
});
