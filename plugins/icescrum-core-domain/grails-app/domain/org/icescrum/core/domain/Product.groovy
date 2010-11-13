/*
 * Copyright (c) 2010 iceScrum Technologies.
 *
 * This file is part of iceScrum.
 *
 * iceScrum is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License.
 *
 * iceScrum is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with iceScrum.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Authors:
 *
 * Vincent Barrier (vincent.barrier@icescrum.com)
 * Stéphane Maldini (stephane.maldini@icescrum.com)
 * Manuarii Stein (manuarii.stein@icescrum.com)
 */




package org.icescrum.core.domain
import org.icescrum.core.domain.preferences.ProductPreferences
import org.icescrum.core.services.SecurityService

class Product extends TimeBox {

  static final long serialVersionUID = -8854429090297032383L

  int planningPokerGameType = PlanningPokerGame.FIBO_SUITE
  String name = ""
  ProductPreferences preferences
  String pkey

  static hasMany = [
          actors: Actor,
          features: Feature,
          stories: Story,
          releases: Release,
          impediments: Impediment,
          domains: Domain,
          teams: Team
  ]

  static mappedBy = [
          features: "backlog",
          actors: "backlog",
          stories: "backlog",
          releases: "parentProduct",
          impediments: "backlog",
          domains: "backlog"
  ]

  static transients = [
          'allUsers',
          'productOwners',
          'erasableByUser'
  ]

  def erasableByUser = false
  def productOwners = null

  static mapping = {
    cache true
    table 'icescrum2_product'
    actors cascade: 'all-delete-orphan', batchSize: 10
    features cascade: 'all-delete-orphan', sort:'rank', batchSize: 10
    stories cascade:'all-delete-orphan', sort: 'rank', 'label':'asc', batchSize: 25
    domains cascade: 'all-delete-orphan', batchSize: 10
    releases cascade: 'all-delete-orphan', batchSize: 10, sort: 'id'
    impediments cascade: 'all-delete-orphan', batchSize: 10
    pkey( index:'p_key_index')
    name(index: 'p_name_index')
  }

  static constraints = {
    name(blank: false, maxSize:200, unique:true)
    pkey(blank:false, maxSize:10, matches:/[A-Z][A-Z0-9]*/, unique:true)
  }

  @Override
  int hashCode() {
    final int prime = 31
    int result = 1
    result = prime * result + ((!name) ? 0 : name.hashCode())
    return result
  }

  //void setProductKey(String key){
    //productKey = new ProductKey()
    //productKey.id = key
  //}

  @Override
  boolean equals(obj) {
    if (this.is(obj))
      return true
    if (obj == null)
      return false
    if (getClass() != obj.getClass())
      return false
    final Product other = (Product) obj
    if (name == null) {
      if (other.name != null)
        return false
    } else if (!name.equals(other.name))
      return false
    return true
  }

  int compareTo(Product obj) {
    return name.compareTo(obj.name);
  }

  def getAllUsers(){
    def users = []
    this.teams?.each{
      if(it.members)
        users.addAll(it.members)
    }
    if (this.productOwners)
      users.addAll(this.productOwners)
    return users.asList().unique()
  }

  static recentActivity(Product currentProductInstance) {
    executeQuery("SELECT DISTINCT a.activity " +
            "FROM grails.plugin.fluxiable.ActivityLink as a, org.icescrum.core.domain.Product as p " +
            "WHERE a.type='product' " +
            "and p.id=a.activityRef " +
            "and p.id=:p " +
            "ORDER BY a.activity.dateCreated DESC", [p: currentProductInstance.id], [max: 15])
  }

  def aclUtilService
  def getProductOwners() {
    //Only used when product is being imported
    if (this.productOwners) {
      return this.productOwners
    }
    else {
      def acl = aclUtilService.readAcl(this.getClass(), this.id)
      def productOwnersList = User.withCriteria {
        or {
          acl.entries.findAll {it.permission in SecurityService.productOwnerPermissions}*.sid.each {sid ->
            eq('username', sid.principal)
          }
        }
      }
      return productOwnersList
    }
  }
}