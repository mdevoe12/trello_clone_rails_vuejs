<template>
  <draggable v-model="lists" :options="{group: 'lists'}" class="board dragArea" @end="listMoved">
    <list v-for="(list, index) in lists" :list="list"></list>
    
    <div class="list">
      <a v-if="!editing" v-on:click="startEditing">Add a List</a>
      <textarea v-if="editing" ref="message" v-model="message" class="form-control mb-1"></textarea>
      <button v-if="editing" v-on:click="createList" class="btn btn-secondary">Add</button>
      <a v-if="editing" v-on:click="editing=false">Cancel</a>
    </div>
  </draggable>
</template>

<script>
import draggable from 'vuedraggable'
import list from 'components/list'

export default {
  components: { draggable, list },

  computed: {
    lists: {
      get() {
        return this.$store.state.lists
      },
      set(value) {
        this.$store.state.lists = value
      },
    },
  },

  data: function() {
    return {
      editing: false,
      message: "",
    }
  },

  methods: {
    startEditing: function() {
      this.editing = true 
      this.$nextTick(() => { this.$refs.message.focus() })
    },
    
    listMoved: function(event) {
      var data = new FormData
      
      data.append("list[position]", event.newIndex + 1)
    

      Rails.ajax({
        url: `/lists/${this.lists[event.newIndex].id}/move`,
        type: "PATCH",
        data: data,
        dataType: "json",
        beforeSend: function() { return true },
      })
    },
    
    createList: function() {
      var data = new FormData
      data.append("list[name]", this.message)

      Rails.ajax({
        url: "/lists",
        type: "POST",
        data: data,
        dataType: "json",
        beforeSend: function() { return true },
        success: (data) => {
          this.$store.commit('addList', data)
          this.message = ""
          this.editing = false
        }
      })
    }
  }
}

</script>

<style scoped>
.dragArea {
  min-height: 20px;
}

.board {
  overflow-x: auto;;
  white-space: nowrap;
}

.list {
  background: #E2E4E6;
  border-radius: 3px;
  display: inline-block;
  margin-right: 20px;
  padding: 10px;
  vertical-align: top;
  width: 270px;
}
</style>
